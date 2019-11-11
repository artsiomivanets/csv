# frozen_string_literal: true

class AsciiRenderer
  NL = "\n"
  SEPARATOR_BORDER = '-'
  CELL_BORDER = '|'
  CELL_CORNER = '+'
  TO_BEGINING = 0
  TO_END = -1
  SPACE = ' '

  def initialize(table)
    @table = table
    @spaces_by_cell = spaces_by_cell
  end

  def render
    render_rows
  end

  def spaces_by_cell
    Array.new(@table.coll_amount)
         .each_with_index
         .map { |_, i| coll_width(i) }
  end

  def coll_width(coll_number)
    @table.by_coll(coll_number)
          .map { |n| only_digits?(n) ? [n] : n.split(' ') }
          .flatten
          .max_by(&:size)
          .size
  end

  def only_digits?(str)
    str.scan(/^[a-z][a-z\s]*$/).empty?
  end

  def items_splited_by_lines(row)
    row.map { |cell| only_digits?(cell) ? [cell] : cell.split(' ') }
  end

  def format_item(item, cell_number)
    spaces_amount = @spaces_by_cell[cell_number]
    return SPACE * spaces_amount unless item

    spaces_to_insert = SPACE * (spaces_amount - item.size)

    if number?(item)
      "#{spaces_to_insert}#{item}"
    else
      "#{item}#{spaces_to_insert}"
    end
  end

  def number?(elem)
    !elem.match(/[a-zA-Z]/)
  end

  def render_line(items, line_number)
    items
      .each_with_index
      .map { |item, cell_number| format_item(item[line_number], cell_number) }
      .join(CELL_BORDER)
      .insert(TO_BEGINING, CELL_BORDER)
      .insert(TO_END, CELL_BORDER)
  end

  def render_row(row)
    items = items_splited_by_lines(row)
    amount_lines_in_row = items.max_by(&:size).size

    Array
      .new(amount_lines_in_row)
      .each_with_index
      .map { |_, line_number| render_line(items, line_number) }.join(NL)
  end

  def render_rows
    first_separator = render_row_separator(true)
    separator = render_row_separator

    @table.body
          .map { |row| render_row(row) }
          .join("#{NL}#{separator}#{NL}")
          .insert(TO_BEGINING, "#{first_separator}#{NL}")
          .insert(TO_END, "#{NL}#{separator}#{NL}")
  end

  def render_row_separator(is_first = false)
    @spaces_by_cell
      .map { |n| SEPARATOR_BORDER * n }
      .join(is_first ? SEPARATOR_BORDER : CELL_CORNER)
      .insert(TO_BEGINING, CELL_CORNER)
      .insert(TO_END, CELL_CORNER)
  end
end
