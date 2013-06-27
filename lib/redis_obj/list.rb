class RedisObj::List < RedisObj::Base
  include Enumerable

  def first num=1
    lrange(0,num-1)
  end

  def take n
    first(n)
  end

  def last num=1
    lrange(-1*num,-1)
  end

  def to_a
    lrange(0,-1)
  end

  def lindex(index)
    redis.lindex(key,index)
  end
  alias [] lindex
  alias at lindex

  def lset(index, value)
    redis.lset(key, index, value)
  end
  alias []= lset

  def llen
    redis.llen(key)
  end
  alias length llen
  alias size llen
  alias count llen

  def lpop
    redis.lpop(key)
  end
  alias shift lpop

  def lpush val
    redis.lpush(key,val)
  end
  alias unshift lpush

  def rpop
    redis.rpop(key)
  end
  alias pop rpop

  def rpush val
    redis.rpush(key,val)
  end
  alias << rpush
  alias push rpush

  def include?(val)
    warn('Calling include on redis list, must pull down entire list to process')
    !!find {|v| v == val}
  end

  def drop n
    redis.ltrim(key,n,-1)
    self
  end

  def sample n=1
    cnt = llen
    if n==1
      lindex(rand(cnt))
    else
      arr = []
      n.times do
        arr << lindex(rand(cnt))
      end
      arr
    end
  end

  # Make future proof for new versions of redis
  def method_missing method, *arguments, &blk
    if redis.respond_to?(method)
      # If its a method available to redis just pass it along with the key
      # as the first argument
      redis.__send__(method,key,*arguments,&blk)
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    redis.respond_to?(method) || super
  end

  def_delegators :_delegated_to_a, :pack, :join, :each, :uniq

  private

  def _delegated_to_a
    warn('Calling include on redis list, must pull down entire list to process')
    to_a
  end
end
