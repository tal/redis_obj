class RedisObj::Base
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

  private

  def get_keys(keys)
    if keys.first.respond_to?(:key)
      keys.collect(&:key)
    else
      keys
    end
  end
end
