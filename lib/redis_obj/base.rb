class RedisObj::Base
  extend Forwardable
  attr_accessor :key, :redis
  def initialize redis, key=nil
    unless key
      key = redis
      redis = RedisObj.redis
    end
    @key = key
    @redis = redis
  end

  def == other
    self.class == other.class and self.key == other.key
  end

  def del_key
    redis.del(key)
  end

  def clear
    redis.del(key)
  end

  def get_keys(keys)
    keys = keys.flatten
    if keys.first.respond_to?(:key)
      keys.collect(&:key)
    else
      keys
    end
  end
end
