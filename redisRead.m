function redisRead(ctx, n)
    if nargin < 2
        n = 1024;
    end

    ctx.buf = [ctx.buf fread(ctx.socket, n)];
end
