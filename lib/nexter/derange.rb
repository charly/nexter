module Nexter
  class Derange

    attr_reader :model, :table_name

    attr_accessor :delimiter, :columns

    attr_accessor :sign, :direction, :trunks

    def initialize(model)
      @model = model
      @table_name = model.class.table_name
      @trunks = []
    end

    def trunk
      raise unless columns

      trunk = columns.map do |col|
        if range_value = value_of(col[0])
          "#{col[0]} = '#{range_value}'"
        else
          "#{col[0]} IS NULL"
        end
      end.join(' AND ')

      trunks << trunk
      "#{trunk} AND" unless trunk.blank?
    end

    def bigger_than
      if delimiter_value = value_of(delimiter)
        "#{delimiter} #{get_bracket(sign)} '#{delimiter_value}'"
      else
        "#{delimiter} IS NULL AND #{table_name}.id > #{model.id}"
      end
    end

    def get_bracket(sign)
      sign == -1 ? '<' : '>'
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
