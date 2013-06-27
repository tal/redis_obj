class RedisObj::Hash < RedisObj::Base
  include Enumerable

  def hdel field
    redis.hdel(key,field)
  end
  alias delete hdel

  def incby field, amt
    if amt.is_a?(Float)
      redis.hincrbyfloat(key,field,amt)
    else
      redis.hincrby(key,field,amt)
    end
  end
  alias hincrby incby
  alias hincrbyfloat incby
  alias hincbyfloat incby

  # Increment by one
  def inc field
    incby(field,1)
  end
  alias incr inc

  # Decriment by one
  def dec field
    incby(field,-1)
  end
  alias decr dec

  def hmget *fields
    redis.hmget(key,*fields)
  end
  alias values_at hmget

  def hmset *fields
    redis.hmset(key,*fields)
  end

  def hvals
    redis.hvals(key)
  end
  alias values hvals

  def hkeys
    redis.hkeys(key)
  end

  def hexists field
    redis.hexists(key,field)
  end
  alias key? hexists
  alias has_key? hexists

  def hget field
    redis.hget(key,field)
  end
  alias [] hget

  def hset field, val
    redis.hset(key,field,val)
  end
  alias []= hset

  def hgetall
    redis.hgetall(key)
  end
  alias to_h hgetall

  def to_a
    to_h.to_a
  end

  def each &blk
    to_a.each(&blk)
  end

  def hlen
    redis.hlen(key)
  end
  alias size hlen
  alias count hlen
  alias length hlen

  def clear
    redis.del(key) and self
  end

  def empty?
    hlen == 0
  end

  def has_key? key
    keys.include?(key)
  end
  alias include? has_key?
  alias member? has_key?

  def has_value? val
    values.include?(val)
  end

  def merge! hsh
    redis.hmset(key,hsh.to_a.flatten)
    self
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
      if method.to_s[0] != 'h' && (new_method = "h#{method}") && redis.respond_to?(new_method)
        self.send(new_method,*arguments,&blk)
      else
        super
      end
    end
  end

  def respond_to_missing?(method, include_private = false)
    return true if redis.respond_to?(method)
    method = method.to_s
    method[0] != 'h' && redis.respond_to?("h#{method}") or super
  end
end
