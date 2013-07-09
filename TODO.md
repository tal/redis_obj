* Detect if the redis client is currently pipelined, an instance of `Redis::Pipeline` and warn or error in that situation.
* Add range support to `List#[]`
* Optionally cache values when you pull down entire set
* In storage methods generate a random destination key if not given
