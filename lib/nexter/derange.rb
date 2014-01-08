module Nexter
  class Derange

    attr_reader :model

    attr_accessor :delimiter, :columns

    attr_accessor :sign, :direction, :trunks

    def initialize(model)
      @model = model
      @trunks = []
    end

    def trunk
      raise unless columns
      trunk = columns.map {|col| "#{col[0]} = '#{value_of(col[0])}'"}.join(' AND ')

      trunks << trunk
      "#{trunk} AND" unless trunk.blank?
    end

    def bigger_than
      "#{delimiter} #{get_bracket(sign)} '#{value_of(delimiter)}'"
    end

    def get_bracket(sign)
      sign == -1 ? '<' : '>'
    end

    def value_of(cursor)
      splits = cursor.split(".")
      if splits.first == model.class.table_name || splits.size == 1
        model.send(splits.last)
      else
        asso = model.reflections.keys.grep(/#{splits.first.singularize}/).first
        model.send(asso).send(splits.last)
      end
    end
  end
end
