function reply = redisParseMultiBulk(ctx)
    loadRedisEnvironment;

    reply = [];
    reply.type = REDIS_REPLY_ARRAY;
    reply.data = [];

    h = redisParseSimpleString(ctx, '*');
    if h.type == REDIS_REPLY_ERROR
        reply = h;
        return;
    end

    len = str2num(h.data);

    reply.data = cell(1,len);
    for i=1:len
        reply.data{i} = redisGetReply(ctx);
    end
end
