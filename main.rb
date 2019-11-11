# frozen_string_literal: true

class Csv
  def initialize(csv_string, converter)
    parsed_data = parse(csv_string)
    headers, *body = parsed_data
    converted_data = body.map { |row| convert(row, headers, converter) }
    @table = [headers, *converted_data]
  end

  def convert(row, headers, converter)
    row.each_with_index.map { |item, i| converter.call(item, headers[i]) }
  end

  def parse(csv_string)
    csv_string.split("\n")
              .map { |n| n.split(';') }
  end

  def body
    @table.slice(1, @table.size)
  end

  def by_row(row_number)
    body[row_number]
  end

  def by_coll(coll_number)
    body.map { |row| row[coll_number] }
  end

  def coll_amount
    @table.first.size
  end
end
