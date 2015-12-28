function ctx = redisConnect(host, port)
    s = tcpip(host, port);
    fopen(s);
    ctx = [];
    ctx.socket = s;
    ctx.buf = '';
end
