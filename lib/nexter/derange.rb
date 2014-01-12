module Nexter
  class Derange

    attr_reader :model, :table_name, :reorder

    attr_accessor :delimiter, :columns

    attr_accessor :sign, :direction, :trunks, :relative_dir

    DIREC  = {asc: 1, desc: -1}
    GOTO = {next: 1, previous: -1}


    def initialize(model, goto = :next)
      @model = model
      @table_name = model.class.table_name
      @trunks = []
      @reorder = false
      @goto = goto
    end

    def set_vals(order_vals, order_col)
      @columns = order_vals
      @delimiter = order_col[0]
      @direction = order_col[1]
      @sign      = signature(direction, @goto)
      @relative_dir = get_direction(sign)
    end

    def trunk
      raise unless columns
      trunk = range
      trunks << trunk
      "#{trunk} AND" unless trunk.blank?
    end

    def range
      trunk = columns.map do |col|
        if range_value = value_of(col[0])
          "#{col[0]} = '#{range_value}'"
        else
          "#{col[0]} IS NULL"
        end
      end.join(' AND ')
    end

    def slice
      if delimiter_value = value_of(delimiter)
        delimited = "#{delimiter} #{get_bracket(sign)} '#{delimiter_value}'"
        if @columns.blank?
          delimited = delimited + " OR #{delimiter} IS NULL"
        end
        delimited
      else
        @reorder = true
        "#{delimiter} IS NULL AND #{table_name}.id > #{model.id}"
      end
    end

    def get_bracket(sign)
      sign == -1 ? '<' : '>'
    end

    def signature(dir, goto)
      sign = DIREC[dir.to_sym] * GOTO[goto]
    end

    def get_direction(sign)
      sign == -1 ? 'desc' : 'asc'
    end


    def value_of(cursor)
      splits = cursor.split(".")
      if splits.first == table_name || splits.size == 1
        model.send(splits.last)
      else
        asso = model.reflections.keys.grep(/#{splits.first.singularize}/).first
        asso = model.send(asso) and asso.send(splits.last)
      end
    end
  end
end
