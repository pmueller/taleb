require 'test_helper'
require 'store'

class StoreTest < Minitest::Test
  def test_errors_out_with_nil_redis
    assert_raises(RuntimeError) do
      Store.new nil
    end
  end

  def test_stores_hash_as_kv
    hash = {"i like" => ["frogs"], "like frogs" => ["best", "best", "too"]}
    fake_redis = Minitest::Mock.new
    def fake_redis.nil?; false; end
    fake_redis.expect :lrange, [], ["i like", 0, -1]
    fake_redis.expect :rpush, true, ["i like", "frogs"]
    fake_redis.expect :lrange, [], ["like frogs", 0, -1]
    fake_redis.expect :rpush, true, ["like frogs", "best"]
    fake_redis.expect :lrange, ["best"], ["like frogs", 0, -1]
    fake_redis.expect :rpush, true, ["like frogs", "too"]
    fake_redis.expect :lrange, ["best"], ["like frogs", 0, -1]
    s = Store.new fake_redis
    s.store! hash
    fake_redis.verify
  end
end
