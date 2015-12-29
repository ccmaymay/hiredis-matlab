function redisConsumeBuf(ctx, n)
    loadRedisEnvironment;

    if nargin < 2
        ctx.buf = '';
    else:
        ctx.buf = ctx.buf(n:end);
    end
end
