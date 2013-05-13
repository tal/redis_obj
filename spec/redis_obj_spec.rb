require 'spec_helper'

describe RedisObj do
  let(:test_klass) do
    Class.new do
      attr_reader :id
      include RedisObj

      def initialize
        @id = rand(100000)
      end
    end
  end

  context 'custom class' do
    it "should store the" do
      test_klass.should respond_to(:store_redis_in)
      blk = -> { 'foo' }
      test_klass.store_redis_in(&blk)
      test_klass.store_redis_in.should == blk
    end

    it "should set default prefix" do
      test_klass.new.redis_prefix.should start_with('class:')
    end
  end

  let(:obj) {test_klass.new}
  subject {obj}

  context 'with prefix' do
    before { test_klass.store_redis_in { "test:#{id}"} }
    its(:redis_prefix) { should == "test:#{subject.id}" }

    describe 'redis_set defined default key' do
      let(:redis) {mock('Redis')}
      before do
        test_klass.redis_set :friends
        test_klass.redis_set :friends2, key: 'f', redis: redis
        test_klass.redis_set :friends3, key: 'ff', redis: ->{redis}
      end

      it {should respond_to :friends}
      its(:friends) { should be_a(RedisObj::Set) }

      it 'should memoize' do
        f = obj.friends
        obj.friends.should be f
        obj.friends.should be f
        obj.instance_variable_set(:@friends,nil)
        obj.friends.should_not be f
      end

      describe 'friends' do
        subject{obj.friends}

        its(:key) { should == "test:#{obj.id}:friends" }
        # its(:redis) { should be base_redis}
      end

      describe 'friends2' do
        subject{obj.friends2}

        its(:key) { should == "test:#{obj.id}:f" }
        its(:redis) { should be redis }
      end

      describe 'friends3' do
        subject{obj.friends3}

        its(:redis) { should be redis }
      end
    end
  end
end
