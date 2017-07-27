require 'test_helper'
require 'markov/brain'

module Markov
  class BrainTest < Minitest::Test
    def test_errors_out_with_nil_redis
      assert_raises(RuntimeError) do
        Brain.new nil
      end
    end

    def test_think_reads_in_a_sequence
      # assume the brain has been trained on this sentence: 'i like frogs best'
      fake_redis = Minitest::Mock.new
      def fake_redis.nil?; false; end
      fake_redis.expect :scan_each, ["i like", "like frogs"].each
      fake_redis.expect :lrange, ["frogs"], ["i like", 0, -1]
      fake_redis.expect :exists, true, ["like frogs"]
      fake_redis.expect :lrange, ["best"], ["like frogs", 0, -1]
      fake_redis.expect :exists, false, ["frogs best"]

      brain = Brain.new fake_redis
      # remove the randomness from the 'random_key' so we can know the starting and ending spot
      def brain.random_key; "i like"; end

      assert_equal brain.think, "frogs"
      assert_equal brain.think, "best"
      assert_equal brain.send(:next_key), "i like"
    end
  end
end
