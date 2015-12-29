function reply = redisParseBulk(ctx)
    loadRedisEnvironment;

    reply = [];
    reply.type = REDIS_REPLY_STRING;
    reply.data = [];

    while length(ctx.buf) < 5 % $-1\r\n or $0\r\n\r\n
        redisRead(ctx);
    end

    nil_buf = ['$-1', CRLF];
    if strncmp(ctx.buf, nil_buf, length(nil_buf));
        reply.type = REDIS_REPLY_NIL;
        return;
    end

    h = redisParseSimpleString(ctx, '$');
    if h.type == REDIS_REPLY_ERROR
        reply = h;
        return;
    end

    data_end = str2num(h.data);

    while length(ctx.buf) < data_end + 2
        redisRead(ctx);
    end

    if ~strncmp(ctx.buf((data_end+1):end), CRLF, 2)
        reply.type = REDIS_REPLY_ERROR;
        reply.data = 'no terminating crlf';
        return;
    end

    reply.data = ctx.buf(1:data_end);

    redisConsumeBuf(ctx, data_end + 2);
end
