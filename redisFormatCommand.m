function buf = redisFormatCommand(fmt, varargin)
    loadRedisEnvironment;

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

    disp(buf)

    if j <= length(varargin)
        error('too many arguments for format string')
    end
end
