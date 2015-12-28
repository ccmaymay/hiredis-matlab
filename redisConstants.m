REDIS_ERR_IO = 1       % Error in read or write
REDIS_ERR_EOF = 3      % End of file
REDIS_ERR_PROTOCOL = 4 % Protocol error
REDIS_ERR_OTHER = 2    % Everything else...

REDIS_REPLY_STRING = 1
REDIS_REPLY_ARRAY = 2
REDIS_REPLY_INTEGER = 3
REDIS_REPLY_NIL = 4
REDIS_REPLY_STATUS = 5
REDIS_REPLY_ERROR = 6

CRLF = sprintf('\r\n');
