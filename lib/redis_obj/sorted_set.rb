class RedisObj::SortedSet < RedisObj::Base
  def card min=nil,max=nil
    if min
      if min.respond_to?(:max) && min.respond_to?(:min)
        max = min.max
        min = min.min
      end

      redis.zcount(key,min,max)
    else
      redis.zcard(key)
    end
  end
  alias length card
  alias size card
  alias zcount card

  def zincrby amt, member
    redis.zincby(key,amt,member)
  end
  alias incby zincrby

  def inc member
    incrby(1,member)
  end
  alias incr inc

  def dec member
    incrby(-1,member)
  end
  alias decr dec

  def zremrangebyrank start, stop=nil
    if start.respond_to?(:max) && start.respond_to?(:min)
      stop = start.max
      start = start.min
    end

    redis.zremrangebyrank(key,start,stop)
  end

  def zremrangebyscore start, stop=nil
    if start.respond_to?(:max) && start.respond_to?(:min)
      stop = start.max
      start = start.min
    end

    redis.zremrangebyscore(key,start,stop)
  end

  def zinterstore(destination, keys, options = {}, &blk)
    keys = [key]+keys

    redis.zinterstore(destination,keys,options)

    store_block_syntax(destination,&blk)
  end

  def zunionstore(destination, keys, options = {}, &blk)
    keys = [key]+keys

    redis.zunionstore(destination,keys,options)

    store_block_syntax(destination,&blk)
  end

  # Allow for non prefixed versions of the commands to be sent
  # as well as making future proof for new versions of redis
  def method_missing method, *arguments, &blk
    if redis.respond_to?(method)
      # If its a method available to redis just pass it along with the key
      # as the first argument
      redis.__send__(method,key,*arguments,&blk)
    else
      # If redis responds to the method prefixed with an h pass it along
      if method.to_s[0] != 'z' && (new_method = "z#{method}") && redis.respond_to?(new_method)
        self.send(new_method,*arguments,&blk)
      else
        super
      end
    end
  end

  def respond_to_missing?(method, include_private = false)
    return true if redis.respond_to?(method)
    method = method.to_s
    method[0] != 'z' && redis.respond_to?("z#{method}") or super
  end
end
