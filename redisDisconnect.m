function redisDisconnect(ctx)
    loadRedisEnvironment;

    fclose(ctx.socket);
end
