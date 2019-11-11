# frozen_string_literal: true

require 'minitest/autorun'
require './main.rb'

def format_currency(number)
  return '0,01' if number.to_f < 0.01

  whole, decimal = number.to_s.split('.')
  whole_with_commas = whole.chars.to_a.reverse.each_slice(3).map(&:join).join(' ').reverse
  [whole_with_commas, decimal].compact.join(',')
end

class CsvTest < Minitest::Test
  def test_some
    result = File.read('fixtures/result.txt')
    csv_string = File.read('fixtures/table.txt')

    convert = ->(item, type) { type.eql?('money') ? format_currency(item) : item }
    table = Csv.new(csv_string, convert)
    assert_equal AsciiRenderer.new(table).render, result
  end
end
