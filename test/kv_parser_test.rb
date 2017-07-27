require 'test_helper'
require 'kv_parser'

class KVParserTest < Minitest::Test
  def test_parses_into_correct_form
    text = "i like frogs that are blue"
    results = KVParser.parse text

    assert_instance_of Hash, results
    assert_equal results.keys, ["i like", "like frogs", "frogs that", "that are"]
    assert_equal results["i like"], ["frogs"]
    assert_equal results["like frogs"], ["that"]
  end

  def test_parse_handles_duplicates_correctly
    text = "i like frogs i like pastries"
    results = KVParser.parse text

    assert_equal results["i like"], ["frogs", "pastries"]
  end

  def test_parse_ignores_whitespace
    text = "    i\nlike       frogs  \n   "
    results = KVParser.parse text

    assert_equal results.keys, ["i like"]
    assert_equal results["i like"], ["frogs"]
  end
end
