function b = redisIsOpen(ctx)
    loadRedisEnvironment;

    b = strcmp(get(ctx.socket, 'Status'), 'open');
end
