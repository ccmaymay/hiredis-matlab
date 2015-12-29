function reply = redisGetReply(ctx)
    disp('getreply')

    loadRedisEnvironment;

    while length(ctx.buf) < 1
        redisRead(ctx);
    end
    switch ctx.buf(1)
        case '*'
            disp('*')
            reply = redisParseMultiBulk(ctx);
        case '$'
            disp('$')
            reply = redisParseBulk(ctx);
        case ':'
            disp(':')
            reply = redisParseInteger(ctx);
        case '+'
            disp('+')
            reply = redisParseSimpleString(ctx);
        case '-'
            disp('-')
            reply = redisParseError(ctx);
        otherwise
            reply = [];
            reply.type = REDIS_REPLY_ERROR;
            reply.data = 'unknown reply type';
    end
end
