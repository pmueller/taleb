require 'test_helper'
require 'markov/mouth'

module Markov
  class MouthTest < Minitest::Test
    def test_errors_out_with_nil_brain
      assert_raises(RuntimeError) do
        Mouth.new nil
      end
    end

    def test_speak_output_the_correct_number_of_words
      fake_brain = Minitest::Mock.new
      def fake_brain.nil?; false; end
      def fake_brain.think; "word"; end

      mouth = Mouth.new fake_brain
      assert_match /(word.?){20}/, mouth.speak(20)
    end

    def test_speak_outputs_random_number_of_words
        fake_brain = Minitest::Mock.new
        def fake_brain.nil?; false; end
        def fake_brain.think; "word"; end

        mouth = Mouth.new fake_brain
        sentence = mouth.speak.split(' ')
        assert sentence.length <= 50
        assert sentence.length >= 15
    end

    def test_speak_ends_in_punctuation
        fake_brain = Minitest::Mock.new
        def fake_brain.nil?; false; end
        def fake_brain.think; "word"; end

        mouth = Mouth.new fake_brain
        sentence = mouth.speak.split(' ')

        assert_match /word(\?|\!|\.)/, sentence[-1]
    end

    def test_speak_excludes_punctuation_if_already_there
        fake_brain = Minitest::Mock.new
        def fake_brain.nil?; false; end
        def fake_brain.think; "word!"; end

        mouth = Mouth.new fake_brain
        sentence = mouth.speak.split(' ')

        assert_equal sentence[-1], "word!"
    end
  end
end
