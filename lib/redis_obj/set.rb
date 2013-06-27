class RedisObj::Set < RedisObj::Base
  include Enumerable

  def members
    redis.smembers(key)
  end
  alias to_a members

  def ismember val
    redis.sismember(key,val)
  end
  alias include? ismember

  def inter *keys
    redis.sinter(key,*get_keys(keys))
  end
  alias & inter

  def interstore destination, *keys, &blk
    redis.sinterstore(destination,key,*get_keys(keys))
    store_block_syntax(destination,&blk)
  end

  def diff *keys
    redis.sdiff(key,*get_keys(keys))
  end
  alias - diff

  def diffstore destination, *keys, &blk
    redis.sdiffstore(destination,key,*get_keys(keys))
    store_block_syntax(destination,&blk)
  end

  def union *keys
    redis.sunion(key,*get_keys(keys))
  end
  alias | union

  def unionstore destination, *keys, &blk
    redis.sunionstore(destination,key,*get_keys(keys))
    store_block_syntax(destination,&blk)
  end

  def pop
    redis.pop(key)
  end

  def add val
    redis.sadd(key,val)
  end
  alias << add

  def rem val
    redis.srem(key,val)
  end

  def srandmember num=1
    redis.srandmember(key,num)
  end

  def card
    redis.scard(key)
  end
  alias length card
  alias size card
  alias count card

  def each &blk
    to_a.each(&blk)
  end
end
