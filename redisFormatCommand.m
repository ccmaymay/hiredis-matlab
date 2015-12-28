function buf = redisFormatCommand(fmt, ...)
    fmt_pieces = strsplit(fmt);

    buf = sprintf('*%d\r\n', length(pieces));

    for i=1:length(fmt_pieces)
        fmt_piece = fmt_pieces(i);
        va_piece = va(i);
        if p(1) == '%' && p(2) ~= '%'
            piece_buf = sprintf(fmt_piece, va_piece);
            buf = [buf sprintf('$%d\r\n%s\r\n', length(piece_buf), piece_buf)];
        else
            buf = [buf fmt_piece];
        end
    end
end
