class Store
  def initialize(redis)
    raise "redis is invalid" if redis.nil?
    @redis = redis
  end

  def store!(mapping)
    mapping.each do |key, val_arr|
      val_arr.each do |val|
        redis.rpush(key, val) unless redis.lrange(key, 0, -1).include?(val)
      end
    end
  end

  private

  attr_reader :redis
end
