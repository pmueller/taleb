class KVParser
  class << self
    # TODO: deal with junk that slack puts in for images, channels, emoji, etc
    # eg: "<@U023BECGF|bobby> has joined the channel"
    def parse(text="")
      ret = {}

      text.strip.split.each_cons(3) do |word_triplet|
        key = word_triplet.take(2).join(" ")
        val = word_triplet[2]

        if ret[key].nil?
          ret[key] = [val]
        else
          ret[key] << val
        end
      end

      ret
    end
  end
end
