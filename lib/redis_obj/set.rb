class RedisObj::Set < RedisObj::Base
  include Enumerable

  def smembers
    redis.smembers(key)
  end
  alias to_a smembers

  def each &blk
    to_a.each(&blk)
  end

  def sismember val
    redis.sismember(key,val)
  end
  alias include? sismember

  def sinter *keys
    redis.sinter(key,*get_keys(keys))
  end
  alias & sinter
  alias intersection sinter

  def sinterstore destination, *keys, &blk
    store_block_syntax(:sinterstore,destination,keys,&blk)
  end

  def sdiff *keys
    redis.sdiff(key,*get_keys(keys))
  end
  alias - sdiff
  alias difference sdiff

  def sdiffstore destination, *keys, &blk
    store_block_syntax(:sdiffstore,destination,keys,&blk)
  end

  def sunion *keys
    redis.sunion(key,*get_keys(keys))
  end
  alias | sunion
  alias + sunion

  def sunionstore destination, *keys, &blk
    store_block_syntax(:sunionstore,destination,keys,&blk)
  end

  def pop
    redis.pop(key)
  end

  def add val
    redis.sadd(key,val)
    self
  end
  alias << add

  def add? val
    redis.sadd(key,val) ? self : nil
  end

  def remove(val)
    srem(val)
    self
  end

  def remove?(val)
    srem(val) ? self : nil
  end

  def srandmember num=1
    redis.srandmember(key,num)
  end
  alias sample srandmember

  def scard
    redis.scard(key)
  end
  alias length scard
  alias size scard
  alias count scard

  def empty?
    scard == 0
  end

  def delete_if(&blk)
    vals_to_delete = select(&blk)
    redis.srem(key,vals_to_delete)
    vals_to_delete
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
      if method.to_s[0] != 's' && (new_method = "s#{method}") && redis.respond_to?(new_method)
        self.send(new_method,*arguments,&blk)
      else
        super
      end
    end
  end

  def respond_to_missing?(method, include_private = false)
    return true if redis.respond_to?(method)
    method = method.to_s
    method[0] != 's' && redis.respond_to?("s#{method}") or super
  end

  private

  # If a block is passed yeild up the new key object and
  # then delete the key afterwards
  def store_block_syntax(command, destination, keys, &blk)
    if block_given?
      keys.unshift destination
      destination = SecureRandom.uuid
    end

    keys.unshift(key)
    redis.__send__(command,destination,*get_keys(keys))

    new_key = self.class.new(redis,destination)

    if block_given?
      begin
        yield(new_key)
      ensure
        redis.del(destination)
      end
    else
      new_key
    end
  end
end
