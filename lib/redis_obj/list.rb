class RedisObj::List < RedisObj::Base
  include Enumerable

  def blpop *args
    redis.blpop(key,*args)
  end

  def brpop *args
    redis.brpop(key,*args)
  end

  def brpoplpush(destination, options = {})
    redis.brpoplpush(key,destination,options)
  end

  def lindex(index)
    redis.lindex(key,index)
  end
  alias [] lindex

  def linsert(where, pivot, value)
    redis.linsert(key,where,pivot,value)
  end

  def lrange(start, stop)
    redis.lrange(key, start, stop)
  end

  def to_a
    lrange(0,-1)
  end

  def each &blk
    to_a.each(&blk)
  end

  def lrem(count, value)
    redis.lrem(key, count, value)
  end

  def lset(index, value)
    redis.lset(key, index, value)
  end
  alias []= lset

  def ltrim(start, stop)
    redis.ltrim(key, start, stop)
  end

  def len
    redis.llen(key)
  end
  alias length len
  alias size len
  alias count len

  def lpop
    redis.lpop(key)
  end
  alias shift lpop

  def lpush val
    redis.lpush(val)
  end
  alias unshift lpush

  def lpushx val
    redis.lpushx(key,val)
  end

  def rpop
    redis.rpop(key)
  end
  alias pop rpop

  def rpoplpush destination
    redis.rpoplpush(key, destination)
  end

  def rpush val
    redis.rpush(key,val)
  end
  alias << rpush
  alias push rpush

  def rpushx val
    redis.rpushx(key,val)
  end
end
