require "taleb/version"
require "redis"
require "slack-ruby-bot"
require "kv_parser"
require "store"
require "markov/brain"
require "markov/mouth"

module Taleb
  class Bot < SlackRubyBot::Bot
    match /^(.*)$/ do |client, data, match|
      redis = Redis.new
      store = Store.new(redis)
      parsed_message = KVParser.parse match[0]
      store.store! parsed_message
      if rand < 0.01 || match[0] == "taleb justdoit"
        client.typing channel: data.channel
        mouth = Markov::Mouth.new(Markov::Brain.new(redis))
        client.say(channel: data.channel, text: mouth.speak)
      end
    end
  end
end
