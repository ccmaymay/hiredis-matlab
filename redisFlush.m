function ctx = redisFlush(ctx)
    disp('flush')

    loadRedisEnvironment;

    if ~redisIsOpen(ctx)
        error(sprintf('redis connection to %s:%d is closed', ctx.host, ctx.port))
    end

    n = get(ctx.socket, 'BytesAvailable');
    if n > 0
        disp(sprintf('fread BytesAvailable (%d)', n))
        ctx.buf = [ctx.buf char(fread(ctx.socket, n)')];
    end
end
