function reply = redisParseSimpleString(ctx, type_char)
    loadRedisEnvironment;

    if nargin < 2
        type_char = '+'
    end

    reply = [];
    reply.type = REDIS_REPLY_STATUS;
    reply.data = [];

    while length(ctx.buf) < 3 % +\r\n
        redisRead(ctx);
    end

    if ctx.buf(1) ~= type_char
        reply.type = REDIS_REPLY_ERROR;
        reply.data = 'mismatched type';
        return;
    end

    breaks = findstr(CRLF, ctx.buf);
    while length(breaks) < 1
        redisRead(ctx);
        breaks = findstr(CRLF, ctx.buf);
    end

    data_end = breaks(1) - 1;

    reply.data = ctx.buf(2:data_end);

    redisConsumeBuf(ctx, data_end + 2);
end
