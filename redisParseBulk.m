function reply = redisParseBulk(ctx)
    reply = [];
    reply.type = REDIS_REPLY_STRING;
    reply.data = [];

    while length(ctx.buf) < 5 % $-1\r\n
        redisRead(ctx);
    end

    if strcmp(ctx.buf, ['$-1', CRLF])
        reply.type = REDIS_REPLY_NIL;
        return;
    end

    h = redisParseSimpleString(ctx, '$');
    if h.type == REDIS_REPLY_ERROR
        reply = h;
        return;
    end

    data_end = str2num(h.data);

    while length(ctx.buf) + 2 < data_end
        redisRead(ctx);
    end

    if ~strcmp(ctx.buf((data_end+1):(data_end+2)), CRLF)
        reply.type = REDIS_REPLY_ERROR;
        reply.data = 'no terminating crlf';
        return;
    end

    reply.data = ctx.buf(1:data_end);

    redisConsumeBuf(ctx, data_end + 2);
end
