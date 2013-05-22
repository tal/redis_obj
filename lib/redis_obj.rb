require 'ostruct'

%w{
  version
  base
  set
  sorted_set
  hash
  relations
}.each do |f|
  require "redis_obj/#{f}"
end

module RedisObj
  class << self
    attr_accessor :redis
  end

  def self.included reciever
    raise NameError, "Please include RedisObj::Relations instead of this module"
  end
end
