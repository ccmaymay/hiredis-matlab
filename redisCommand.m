function reply = redisCommand(ctx, fmt, ...)
    redisAppendCommand(ctx, fmt, ...);
    reply = redisGetReply(ctx);
end
