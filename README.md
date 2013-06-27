# RedisObj

This gem allows you to treat redis stores like ruby objects.

    RedisObj::Set.new('myset').include?('foo')

Will run the redis command

    sismember myset foo

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
    # => smembers set1

    RedisObj::Set.new('set1') & RedisObj::Set.new('set2')
    #=> sinter set1 set2

    RedisObj::Set.new('set1') - RedisObj::Set.new('set2')
    # => sdiff set1 set2

You can also just call the methods staright out

    RedisObj::Hash.new('hash1').mget('key','key2')
    # => hmget hash1 key key2

There are too many methods to list but check out the source to see all the ones listed:

* [Hash](https://github.com/tal/redis_obj/blob/master/lib/redis_obj/hash.rb)
* [List](https://github.com/tal/redis_obj/blob/master/lib/redis_obj/list.rb)
* [Set](https://github.com/tal/redis_obj/blob/master/lib/redis_obj/set.rb)
* [SortedSet](https://github.com/tal/redis_obj/blob/master/lib/redis_obj/sorted_set.rb)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
