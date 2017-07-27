# Taleb

Markov chain chat bot for slack.

It stores any messages it hears in `redis`, broken into 2 word key/value pairs.
It has a low percent chance to respond back to the message with a sentence that's 15-50 words in length.
Sentences are constructed by:
  - starting at a random key
  - select from the list of 'next word' values for that key, each with an equal probablity of being chosen
  - make the chosen 'next word' the new key and repeat the previous step
  - if we reach a terminal key (one that has no 'next word') then go back to the first step with a random key


## Usage instructions
```
cp template.env .env
# add your slack bot api token to .env
bundle install
./bin/run
```

## Initial data set for the bot (optional)
If you want to 'train' the bot with specific text, you can use the `Store` and `KVParser` classes to do so directly. Something like this:
```
# make sure that 'lib/' is in your load path
require "redis"
require "kv_parser"
require "store"

redis = Redis.new
store = Store.new(redis)

messages = # magically load the messages you want to feed the bot

messages.each do |msg|
  store.store! KVParser.parse(msg)
end
```
