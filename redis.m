classdef redis < handle
    properties
        isOpen
    end

    properties (Access=private)
        buf
        socket
    end

    properties (Constant)
        CRLF = sprintf('\r\n');
        NIL_BUF = sprintf('$-1\r\n');
    end

    methods
        function obj = redis(host, port)
            obj.buf = '';
            obj.socket = tcpip(host, port);
            fopen(obj.socket);
            obj.socket.Terminator = '';

            if ~obj.isOpen
                error(sprintf('failed to open connection to %s:%d', host, port))
            end
        end

        function delete(obj)
            if obj.isOpen
                fclose(obj.socket);
            end
            delete(obj.socket);
        end

        function reply = getReply(obj)
            while length(obj.buf) < 1
                flush(obj);
            end
            switch obj.buf(1)
                case '*'
                    reply = parseMultiBulk(obj);
                case '$'
                    reply = parseBulk(obj);
                case ':'
                    reply = parseInteger(obj);
                case '+'
                    reply = parseSimpleString(obj);
                case '-'
                    reply = parseError(obj);
                otherwise
                    error('unknown reply type')
            end
        end

        function reply = command(obj, fmt, varargin)
            appendCommand(obj, fmt, varargin{:});
            reply = getReply(obj);
        end

        function buf = formatCommand(obj, fmt, varargin)
            fmt_pieces = strsplit(fmt, ' ');

            buf = sprintf('*%d\r\n', length(fmt_pieces));

            j = 1;
            for i=1:length(fmt_pieces)
                fmt_piece = fmt_pieces{i};
                if fmt_piece(1) == '%' && fmt_piece(2) ~= '%'
                    if length(varargin) < j
                        error('not enough arguments for format string')
                    end
                    va_piece = varargin{j};
                    piece_buf = sprintf(fmt_piece, va_piece);
                    j = j + 1;
                else
                    piece_buf = fmt_piece;
                end
                buf = [buf sprintf('$%d\r\n%s\r\n', length(piece_buf), piece_buf)];
            end

            if j <= length(varargin)
                error('too many arguments for format string')
            end
        end

        function appendCommand(obj, fmt, varargin)
            if ~obj.isOpen
                error('cannot write command, connection is closed')
            end

            fwrite(obj.socket, formatCommand(obj, fmt, varargin{:}));
        end

        function isOpen = get.isOpen(obj)
            isOpen = strcmp(obj.socket.Status, 'open');
        end

        function isOpen = set.isOpen(obj, v)
            error('isOpen property cannot be manually set')
        end
    end

    methods (Access=private)
        function consumeBuf(obj, n)
            if nargin < 2
                obj.buf = '';
            else
                obj.buf = obj.buf((n+1):end);
            end
        end

        function n = flush(obj)
            if ~obj.isOpen
                error('cannot flush, connection is closed')
            end

            n = obj.socket.BytesAvailable;
            if n > 0
                obj.buf = [obj.buf char(fread(obj.socket, n)')];
            end
        end

        function reply = parseBulk(obj)
            reply = redisReply;

            while length(obj.buf) < 5 % $-1\r\n or $0\r\n\r\n
                flush(obj);
            end

            if strncmp(obj.buf, obj.NIL_BUF, length(obj.NIL_BUF));
                reply.type = redisReplyType.NIL;
                reply.data = [];
                consumeBuf(obj, length(obj.NIL_BUF));
            else
                reply.type = redisReplyType.STRING;
                h = parseSimpleString(obj, '$');
                data_end = str2num(h.data);

                while length(obj.buf) < data_end + 2
                    flush(obj);
                end

                if ~strncmp(obj.buf((data_end+1):end), obj.CRLF, 2)
                    error('no terminating crlf')
                end

                reply.data = obj.buf(1:data_end);
                consumeBuf(obj, data_end + 2);
            end
        end

        function reply = parseError(obj)
            reply = parseSimpleString(obj, '-');
            reply.type = redisReplyType.ERROR;
        end

        function reply = parseInteger(obj)
            reply = parseSimpleString(obj, ':');
            reply.type = redisReplyType.INTEGER;
            reply.data = str2num(reply.data);
        end

        function reply = parseMultiBulk(obj)
            reply = redisReply;
            reply.type = redisReplyType.ARRAY;
            h = parseSimpleString(obj, '*');
            len = str2num(h.data);
            reply.data = cell(1,len);
            for i=1:len
                reply.data{i} = getReply(obj);
            end
        end

        function reply = parseSimpleString(obj, type_char)
            if nargin < 2
                type_char = '+';
            end

            reply = redisReply;
            reply.type = redisReplyType.STATUS;
            reply.data = [];

            while length(obj.buf) < 3 % +\r\n
                flush(obj);
            end

            if obj.buf(1) ~= type_char
                error('mismatched type')
            end

            breaks = findstr(obj.CRLF, obj.buf);
            while length(breaks) < 1
                flush(obj);
                breaks = findstr(obj.CRLF, obj.buf);
            end

            data_end = breaks(1) - 1;

            reply.data = obj.buf(2:data_end);

            consumeBuf(obj, data_end + 2);
        end
    end
end
