function n = redisRead(ctx)
    disp('read')

    loadRedisEnvironment;

    if ~redisIsOpen(ctx)
        error(sprintf('redis connection to %s:%d is closed', ctx.host, ctx.port))
    end

    n = length(ctx.buf);
    ctx = redisFlush(ctx);

    if length(ctx.buf) == n
        disp('fread 1')
        buf = fread(ctx.socket, 1);
        while length(buf) == 0
            if ~redisIsOpen(ctx)
                redisReconnect(ctx);
            end

            disp('fread 1')
            buf = fread(ctx.socket, 1);
        end
        ctx.buf = [ctx.buf char(buf')];

        n = length(ctx.buf);
        ctx = redisFlush(ctx);
    end
end
