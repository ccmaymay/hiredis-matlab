function reply = redisGetReply(ctx)
    while length(ctx.buf) < 1
        redisRead(ctx);
    end
    switch ctx.buf(1)
        case '*'
            reply = redisParseMultiBulk(ctx);
        case '$'
            reply = redisParseBulk(ctx);
        case ':'
            reply = redisParseInteger(ctx);
        case '+'
            reply = redisParseSimpleString(ctx);
        case '-'
            reply = redisParseError(ctx);
        otherwise
            reply = [];
            reply.type = REDIS_REPLY_ERROR;
            reply.data = 'unknown reply type';
    end
end
