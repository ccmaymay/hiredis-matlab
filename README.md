# hiredis-matlab

hiredis clone for matlab

## Usage

In this example we connect to a database, get all items from a list, and
store them in a cell `vocab` that can be accessed as, for example, `vocab{47}`.

```
redis_host = 'localhost';
redis_port = 6379;
redis_db = redis(redis_host, redis_port);

vocab_key = 'words';
reply = command(redis_db, 'lrange %s 0 -1', vocab_key);
if reply.type ~= redisReplyType.ARRAY
  if reply.type == redisReplyType.ERROR
    disp(reply.data)
  else
    disp(reply.type)
  end
  error('unexpected reply to vocab lrange')
end

vocab = cell(length(reply.data),1);
for i=1:length(reply.data)
  vocab{i} = reply.data{i}.data;
end
```
