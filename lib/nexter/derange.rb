module Nexter
  class Derange

    attr_reader :model, :compass, :table_name, :reorder

    attr_accessor :delimiter, :columns, :trunks

    delegate :goto, :bracket, :redirection, to: :compass


    def initialize(model, goto)
      @model = model
      @table_name = model.class.table_name
      @trunks = []
      @reorder = false
      @or_null = false
      @compass = Nexter::Compass.new(goto)
    end

    def set_vals(order_vals, order_col)
      @columns = order_vals
      @delimiter = order_col[0]
      compass.direction = order_col[1]
    end

    def where
      "(#{range} #{range.blank? ? '' : 'AND'} #{slice})"
    end

    def reorder
      " #{delimiter} #{redirection}"
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
      if val = value_of(delimiter)
        d = val.is_a?(String) ? val.gsub(/'/, "''") : val
        delimited = "#{delimiter} #{bracket} '#{d}'"
      else
        # @reorder = true
        "#{delimiter} IS NULL AND #{table_name}.id > #{model.id}"
      end
    end

    def value_of(cursor)
      splits = cursor.split(".")
      result = if splits.first == table_name || splits.size == 1
        model.send(splits.last)
      else
        # binding.pry
        asso = model.class.reflections.keys.grep(/#{splits.first.singularize}/).first
        asso = model.send(asso) and asso.send(splits.last)
      end
    end
  end
end
