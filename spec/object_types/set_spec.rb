require 'spec_helper'

describe RedisObj::Set do
  let(:redis_method) {:"some_redis_method!"}
  let(:redis) { double(Redis, redis_method => true) }
  let(:key) { "key#{rand}" }
  let(:val) { rand }
  subject {RedisObj::Set.new(redis,key)}

  describe '#smembers' do
    before do
      expect(redis).to receive(:smembers).with(key).once
    end

    it { subject.smembers }
    it { subject.to_a }
    it { subject.members }
  end

  describe '#sismember' do
    before do
      expect(redis).to receive(:sismember).with(key,val).once
    end

    it { subject.sismember val }
    it { subject.include? val }
    it { subject.ismember val }
  end

  describe 'other key interaction' do
    let(:keys) { %w{key1 key2 key3} }
    let(:objs) { %w{key1 key2 key3}.collect {|k| RedisObj::Set.new(redis,k)} }
    let(:destination) { 'destination' }

    let(:test_key) {keys.first}
    let(:test_objs) {objs.first}

    describe '#sinter' do
      before do
        expect(redis).to receive(:sinter).with(key,*keys).once
      end

      it { subject.sinter *keys }
      it { subject.sinter keys }
      it { subject.inter keys }
      it { subject & keys }
      it { subject.intersection keys }

      it { subject.sinter *objs }
      it { subject.sinter objs }
      it { subject.inter objs }
      it { subject & objs }
      it { subject.intersection objs }
    end

    describe '#sdiff' do
      before do
        expect(redis).to receive(:sdiff).with(key,*keys).once
      end

      it { subject.sdiff *keys }
      it { subject.sdiff keys }
      it { subject.diff keys }
      it { subject - keys }
      it { subject.difference keys }

      it { subject.sdiff *objs }
      it { subject.sdiff objs }
      it { subject.diff objs }
      it { subject - objs }
      it { subject.difference objs }
    end

    describe '#sunion' do
      before do
        expect(redis).to receive(:sunion).with(key,*keys).once
      end

      it { subject.sunion *keys }
      it { subject.sunion keys }
      it { subject.union keys }
      it { subject | keys }
      it { subject + keys }

      it { subject.sunion *objs }
      it { subject.sunion objs }
      it { subject.union objs }
      it { subject | objs }
      it { subject + objs }
    end

    describe '#sinterstore' do
      before do
        expect(redis).to receive(:sinterstore).with(destination,key,*keys).once
      end

      it { subject.sinterstore destination, *keys }
      it { subject.interstore destination, keys }

      it 'should delete key after when returning block' do
        expect(redis).to receive(:del).with(destination).once
        expect(redis).to receive(redis_method).with(destination).once
        expect(SecureRandom).to receive(:uuid).once.and_return(destination)

        subject.sinterstore *keys do |new_key|
          new_key.send redis_method
        end
      end

    end

    describe '#sdiffstore' do
      before do
        expect(redis).to receive(:sdiffstore).with(destination,key,*keys).once
      end

      it { subject.sdiffstore destination, *keys }
      it { subject.diffstore destination, keys }

      it 'should delete key after when returning block' do
        expect(redis).to receive(:del).with(destination).once
        expect(redis).to receive(redis_method).with(destination).once
        expect(SecureRandom).to receive(:uuid).once.and_return(destination)

        subject.sdiffstore *keys do |new_key|
          new_key.send redis_method
        end
      end

    end

    describe '#sunionstore' do
      before do
        expect(redis).to receive(:sunionstore).with(destination,key,*keys).once
      end

      it { subject.sunionstore destination, *keys }
      it { subject.unionstore destination, keys }

      it 'should delete key after when returning block' do
        expect(redis).to receive(:del).with(destination).once
        expect(redis).to receive(redis_method).with(destination).once
        expect(SecureRandom).to receive(:uuid).once.and_return(destination)

        subject.sunionstore *keys do |new_key|
          new_key.send redis_method
        end
      end

    end

  end

  describe '#pop' do
    before do
      expect(redis).to receive(:pop).with(key).once
    end

    it { subject.pop }
  end

  describe '#srandmember' do
    before do
      expect(redis).to receive(:srandmember).with(key,1).once
    end

    it { subject.srandmember }
    it { subject.randmember }
    it { subject.sample }
  end

  describe '#scard' do
    before do
      expect(redis).to receive(:scard).with(key).once
    end

    it { subject.scard }
    it { subject.card }
    it { subject.length }
    it { subject.size }
    it { subject.count }
  end

  describe '#add' do
    let(:ret) {double('return')}
    before do
      expect(redis).to receive(:sadd).with(key,val).once.and_return(ret)
    end

    it { subject.add(val).should be subject }
    it { subject.sadd(val).should be ret }
    it { (subject << val).should be subject }
  end

  describe '#remove' do
    let(:ret) {double('return')}
    before do
      expect(redis).to receive(:srem).with(key,val).once.and_return(ret)
    end

    it { subject.srem(val).should be ret }
    it { subject.remove(val).should be subject }
  end

  it_should_behave_like "a method missing object", 's'
end
