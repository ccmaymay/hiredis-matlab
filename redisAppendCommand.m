function redisAppendCommand(ctx, fmt, ...)
    fwrite(ctx.socket, redisFormatCommand(fmt, ...));
end
