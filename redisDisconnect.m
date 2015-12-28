function redisDisconnect(ctx)
    fclose(ctx.socket);
end
