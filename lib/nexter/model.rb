module Nexter
  class Model
    attr_reader :model
    attr_reader :order_values, :associations

    def initialize(model, relation)
      @model = model
      @order_values = ParseOrder.parse(relation.order_values)
    end

    def values
      @values ||= @order_values.map do |column|
        next unless value = value_of(column[0])
        { col: column[0],
          val: value,
          dir: column[1]
        }
      end.compact
    end

  private
    def value_of(cursor)
      splits = cursor.split(".")
      result = if splits.first == model.class.table_name || splits.size == 1
        model.send(splits.last) if model.respond_to?(splits.last)
      elsif asso = model.class.reflections.keys.grep(/#{splits.first.singularize}/).first
        asso = model.send(asso) and asso.send(splits.last)
      else
        false
      end
    end

  end
end