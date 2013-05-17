require 'spec_helper'

describe RedisObj do
  let(:test_klass) do
    Class.new do
      attr_reader :id
      include RedisObj

      redis_set :friends

      def initialize
        @id = rand(100000)
      end
    end
  end
  subject {test_klass}

  describe "redis_obj" do
    let(:context) {test_klass.new}
    subject {test_klass.redis_friends(context)}

    it {should be_a(RedisObj::Set)}
    its(:key) {should == "class:#{context.id}:friends"}

    context "hash" do
      let(:context) {{id: rand(100000)}}
      before {context.should_receive(:is_a?).and_return(true)}

      it do
        test_klass.redis_prefix(context).should == "class:#{context[:id]}"
      end

      it {should be_a(RedisObj::Set)}
      its(:key) {should == "class:#{context[:id]}:friends"}
    end
  end
end
