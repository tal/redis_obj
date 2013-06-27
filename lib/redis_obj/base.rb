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

  def store_block_syntax(destination)
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

  def get_keys(keys)
    if keys.first.respond_to?(:key)
      keys.collect(&:key)
    else
      keys
    end
  end
end
