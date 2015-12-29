function reply = redisCommand(ctx, fmt, varargin)
    disp('command')

    loadRedisEnvironment;

    redisAppendCommand(ctx, fmt, varargin{:});
    reply = redisGetReply(ctx);
end
