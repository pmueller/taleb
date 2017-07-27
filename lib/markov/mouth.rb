module Markov
  class Mouth
    def initialize(brain)
      raise "markov brain is invalid" if brain.nil?
      @brain = brain
    end

    def speak(num_words=rand(15...50))
      sentence = Array.new(num_words) do
        brain.think
      end.join(' ')

      sentence += ['?', '.', '!'].sample unless sentence[-1] =~ /(\?|\!|\.)/
      sentence
    end

    private

    attr_reader :brain
  end
end
