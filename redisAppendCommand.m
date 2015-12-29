function redisAppendCommand(ctx, fmt, varargin)
    disp('appendcommand')

    loadRedisEnvironment;

    if ~redisIsOpen(ctx)
        error(sprintf('redis connection to %s:%d is closed', ctx.host, ctx.port))
    end

    disp('fwrite')
    fwrite(ctx.socket, redisFormatCommand(fmt, varargin{:}));
end
