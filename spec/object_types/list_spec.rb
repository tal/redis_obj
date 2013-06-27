require 'spec_helper'

describe RedisObj::List do
  let(:redis_method) {:"some_redis_method!"}
  let(:redis) { double(Redis, redis_method => true) }
  let(:key) { "key#{rand}" }
  let(:val) { rand }
  subject {RedisObj::List.new(redis,key)}

  it_should_behave_like "a method missing object"

  describe '#lindex' do
    let(:val) { rand }
    before do
      expect(redis).to receive(:lindex).with(key,val).once
    end

    it { subject.lindex(val) }
    it { subject[val] }
    it { subject.at(val) }
  end

  describe '#first' do
    it "should work with no args" do
      expect(redis).to receive(:lrange).with(key,0,0).once
      subject.first
    end

    it "should work with no args" do
      expect(redis).to receive(:lrange).with(key,0,2).once
      subject.first(3)
    end

    it "should work with no args" do
      expect(redis).to receive(:lrange).with(key,0,2).once
      subject.take(3)
    end
  end

  describe '#last' do
    it "should work with no args" do
      expect(redis).to receive(:lrange).with(key,-1,-1).once
      subject.last
    end

    it "should work with no args" do
      expect(redis).to receive(:lrange).with(key,-3,-1).once
      subject.last(3)
    end
  end

  describe '#set' do
    let(:index) { rand(100000) }
    before do
      expect(redis).to receive(:lset).with(key,index,val).once
    end

    it { subject.lset(index,val) }
    it { subject[index] = val }
  end

  describe '#llen' do
    before do
      expect(redis).to receive(:llen).with(key).once
    end

    it { subject.length }
    it { subject.size }
    it { subject.count }
    it { subject.llen }
  end

  describe '#lpop' do
    before do
      expect(redis).to receive(:lpop).with(key).once
    end

    it { subject.lpop }
    it { subject.shift }
  end

  describe '#lpush' do
    before do
      expect(redis).to receive(:lpush).with(key,val).once
    end

    it { subject.lpush val }
    it { subject.unshift val }
  end

  describe '#rpop' do
    before do
      expect(redis).to receive(:rpop).with(key).once
    end

    it { subject.rpop }
    it { subject.pop }
  end

  describe '#rpush' do
    before do
      expect(redis).to receive(:rpush).with(key,val).once
    end

    it { subject.rpush val }
    it { subject << val}
    it { subject.push val}
  end

end
