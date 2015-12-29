function reply = redisParseError(ctx)
    loadRedisEnvironment;

    reply = redisParseSimpleString(ctx, '-');
    reply.type = REDIS_REPLY_ERROR;
end
