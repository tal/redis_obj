require 'spec_helper'

describe RedisObj::SortedSet do
  let(:redis_method) {:"some_redis_method!"}
  let(:redis) { double(Redis, redis_method => true) }
  let(:key) { "key#{rand}" }
  let(:val) { rand }
  subject {RedisObj::SortedSet.new(redis,key)}

  it_should_behave_like "a method missing object", 'z'
end
