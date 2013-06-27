require 'spec_helper'

describe RedisObj::Hash do
  let(:redis_method) {:"some_redis_method!"}
  let(:redis) { double(Redis, redis_method => true) }
  let(:key) { "key#{rand}" }
  let(:val) { rand }
  subject {RedisObj::Hash.new(redis,key)}

  it_should_behave_like "a method missing object", 'h'

  describe '#hget' do
    let(:index) { rand(10000) }
    before do
      expect(redis).to receive(:hget).with(key,index).once
    end

    it { subject.hget(index) }
    it { subject.get(index) }
    it { subject[index] }
  end

  describe '#hset' do
    let(:index) { rand(10000) }
    let(:val) { rand }
    before do
      expect(redis).to receive(:hset).with(key,index,val).once
    end

    it { subject.hset(index,val) }
    it { subject.set(index,val) }
    it { subject[index] = val}
  end
end
