function reply = redisParseError(ctx)
    reply = redisParseSimpleString(ctx, '-');
    reply.type = REDIS_REPLY_ERROR;
end
