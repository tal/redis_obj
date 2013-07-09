# RedisObj

[![Build Status](https://travis-ci.org/tal/redis_obj.png)](https://travis-ci.org/tal/redis_obj)

This gem allows you to treat redis stores like ruby objects.

    RedisObj::Set.new('myset').include?('foo')

Will run the redis command

    SISMEMBER myset foo

So a hash key would act like a ruby hash, a set a set, and a list an array.

## Installation

Add this line to your application's Gemfile:

    gem 'redis_obj'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis_obj

## Usage

All the RedisObj wrappers have common ruby functions implemented

    RedisObj::Set.new('set1').to_a
    # => SMEMBERS set1

    RedisObj::Set.new('set1') & RedisObj::Set.new('set2')
    #=> SINTER set1 set2

    RedisObj::Set.new('set1') - RedisObj::Set.new('set2')
    # => SDIFF set1 set2

You can also just call the methods staright out

    RedisObj::Hash.new('hash1').mget('key','key2')
    # => HMGET hash1 key key2

### Relations

You can embed redis objects into an object very easily.

    class Foo
      attr_accessor :id, :bar
      include RedisObj::Relation
      redis_set :baz
    end

This will add a class and instance method to the object.

    foo = Foo.new
    foo.id = 123
    foo.baz # => RedisObj::Set.new('foo:123:baz')

Class method:

    Foo.redis_baz(id: 321) # => RedisObj::Set.new('foo:321:baz')
    Foo.redis_baz(OpenStruct.new(id: 'myid')) # => RedisObj::Set.new('foo:myid:baz')

You can override the namespace for all redis relations easily:

    class Foo
      attr_accessor :id, :bar
      include RedisObj::Relation
      store_redis_in { "foons:#{id}:#{bar}" }
      redis_set :baz, key: 'b'
      redis_hash :hashy, key: 'h'
    end

will allow the relations:

    foo = Foo.new
    foo.id = 123
    foo.bar = 'mybar'
    foo.baz # => RedisObj::Set.new('foons:123:mybar:b')
    foo.hashy # => RedisObj::Hash.new('foons:123:mybar:h')

### Examples

For more information on how relations work or how to use the gem check out the [examples](https://github.com/tal/redis_obj/wiki#examples).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
