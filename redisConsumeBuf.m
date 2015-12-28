function redisConsumeBuf(ctx, n)
    if nargin < 2
        ctx.buf = '';
    else:
        ctx.buf = ctx.buf(n:end);
    end
end
