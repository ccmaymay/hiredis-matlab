function reply = redisParseInteger(ctx)
    reply = redisParseSimpleString(ctx, ':');
    reply.type = REDIS_REPLY_INTEGER;
    reply.data = str2num(reply.data);
end
