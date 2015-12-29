function ctx = redisConnect(host, port)
    loadRedisEnvironment;

    ctx = [];
    ctx.host = host;
    ctx.port = port;
    ctx.buf = '';

    s = tcpip(ctx.host, ctx.port);
    fopen(s);
    ctx.socket = s;

    if ~redisIsOpen(ctx)
        error(sprintf('failed to open connection to %s:%d', ctx.host, ctx.port))
    end
end
