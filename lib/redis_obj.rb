require 'ostruct'

%w{
  version
  base
  set
  sorted_set
  hash
}.each do |f|
  require "redis_obj/#{f}"
end

module RedisObj
  module Initializers
    def store_redis_in &blk
      if blk
        @store_redis_in = blk
      else
        @store_redis_in ||= begin
          base_class = self.class.to_s.downcase
          Proc.new { "#{base_class}:#{id}" }
        end
      end
    end

    def redis_prefix ctx
      if ctx.is_a? ::Hash
        ctx = OpenStruct.new(ctx)
      end
      ctx.instance_exec(&store_redis_in)
    end

    def redis_obj type, name, opts={}
      opts[:key] ||= name
      opts[:redis] ||= -> { RedisObj.redis }

      klass_method = "redis_#{name}"
      instance_variable = "@#{name}"

      define_method name do
        unless obj = instance_variable_get(instance_variable)
          obj = self.class.send(klass_method,self)

          instance_variable_set(instance_variable,obj)
        end
        obj
      end

      define_singleton_method klass_method do |context|
        redis = opts[:redis]

        if redis.respond_to?(:call)
          redis = redis.call
        end

        type.new(redis, "#{redis_prefix(context)}:#{opts[:key]}")
      end
    end

    def redis_hash name, opts={}
      redis_obj(RedisObj::Hash,name,opts)
    end

    def redis_set name, opts={}
      redis_obj(RedisObj::Set,name,opts)
    end

    def redis_sorted_set name, opts={}
      redis_obj(RedisObj::SortedSet,name,opts)
    end

    def redis_list name, opts={}
      redis_obj(RedisObj::List,name,opts)
    end

    def inherited subklass
      subklass.instance_variable_set(:@store_redis_in,@store_redis_in)
    end
  end

  module InstanceMethods
    def redis_prefix
      self.class.redis_prefix(self)
    end
  end

  class << self
    attr_accessor :redis
  end


  def self.included klass
    klass.extend Initializers
    klass.send(:include, InstanceMethods)
  end
end
