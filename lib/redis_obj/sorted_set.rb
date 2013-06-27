class RedisObj::SortedSet < RedisObj::Base
  def add score, member
    redis.zadd(key,score,member)
  end

  def rem member
    redis.zrem(key,mem)
  end

  def card min=0,max=0
    if min
      redis.zcount(key,min,max)
    else
      redis.zcard(key)
    end
  end
  alias length card
  alias size card
  alias count card

  def incby amt, member
    redis.zincby(key,amt,member)
  end

  def inc member
    incby(1,member)
  end

  def dec member
    incby(-1,member)
  end

  def range start, stop, opts={}
    redis.zrange(key,start,stop,opts)
  end

  def revrange start, stop, opts={}
    redis.zrevrange(key,start,stop,opts)
  end

  def rangebyscore start, stop, opts={}
    redis.zrangebyscore(key,start,stop,opts)
  end

  def revrangebyscore start, stop, opts={}
    redis.zrevrangebyscore(key,start,stop,opts)
  end

  def rank mem
    redis.rank(key,mem)
  end

  def revrank mem
    redis.revrank(key,mem)
  end

  def remrangebyrank start, stop
    redis.zremrangebyrank(key,start,stop)
  end

  def remrangebyscore start, stop
    redis.zremrangebyscore(key,start,stop)
  end

  def interstore(destination, keys, options = {}, &blk)
    keys = [key]+keys

    redis.zinterstore(destination,keys,options)

    store_block_syntax(destination,&blk)
  end

  def unionstore(destination, keys, options = {}, &blk)
    keys = [key]+keys

    redis.zunionstore(destination,keys,options)

    store_block_syntax(destination,&blk)
  end

end
