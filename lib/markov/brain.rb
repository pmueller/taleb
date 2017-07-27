module Markov
  class Brain
    def initialize(redis)
      raise "redis is invalid" if redis.nil?
      @redis = redis
    end

    def think
      @next_key ||= random_key
      thought = random_val_for(next_key)
      change_next_key(thought)
      thought
    end

    private

    def change_next_key(thought)
      chained_key = [next_key.split(" ")[1], thought].join(" ")
      self.next_key = if vals_exist_for?(chained_key)
                        chained_key
                      else
                        random_key
                      end
    end

    def vals_exist_for?(key)
      redis.exists key
    end

    def random_val_for(key)
      vals_for(key).sample
    end

    def vals_for(key)
      redis.lrange(key, 0, -1)
    end

    def random_key
      keys.sample
    end

    def keys
      @keys ||= redis.scan_each.to_a
    end

    attr_accessor :next_key
    attr_reader :redis
  end
end
