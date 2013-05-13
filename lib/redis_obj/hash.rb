class RedisObj::Hash < RedisObj::Base
  def del field
    redis.hdel(key,field)
  end

  def incby field, amt
    if amt.is_a?(Float)
      redis.hincbyfloat(key,field,amt)
    else
      redis.hincby(key,field,amt)
    end
  end
  alias incbyfloat incby

  def inc field
    incby(field,1)
  end

  def dec field
    incby(field,-1)
  end

  def mget *fields
    redis.hmget(key,*fields)
  end

  def mset *fields
    redis.hmset(key,*fields)
  end

  def vals
    redis.hvals(key)
  end
  alias values vals

  def keys
    redis.hkeys(key)
  end

  def exists field
    redis.hexists(key,field)
  end

  def get field
    redis.hget(key,field)
  end
  alias [] get

  def set field, val
    redis.hset(key,field,val)
  end
  alias []= set

  def getall
    redis.hgetall(key)
  end
  alias to_h getall

  def len
    redis.hlen(key)
  end
  alias size len
  alias count len
  alias length len

  def setnx field, val
    redis.hsetnx(key,field,val)
  end
end
