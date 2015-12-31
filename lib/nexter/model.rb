module Nexter
  class Model
    attr_reader :model
    attr_reader :order_values, :associations

    def initialize(model, relation)
      @model = model
      @order_values = parse relation.order_values
    end

    def values
      @values ||= @order_values.map do |column|
        { col: column[0],
          val: value_of(column[0]),
          dir: column[1]
        }
      end
    end

  private

    def value_of(cursor)
      splits = cursor.split(".")
      result = if splits.first == model.class.table_name || splits.size == 1
        model.send(splits.last) if model.respond_to?(splits.last)
      else
        asso = model.class.reflections.keys.grep(/#{splits.first.singularize}/).first
        asso = model.send(asso) and asso.send(splits.last)
      end
    end

    def parse(order_values)
      order_values.map do |value|
        value.is_a?(String) ? parse_string(value) : parse_arel(value)
      end
    end

    # helper to turn mixed order attributes to a consistant
    def parse_string(string)
      string.split(",").map(&:strip).flat_map do |column|
        splits = column.split(" ").map(&:strip).map(&:downcase)
        splits << "asc" if splits.size == 1
        splits
      end
    end

    def parse_arel(arel)
      ["#{arel.value.name}", "#{arel.direction}"]
    end
  end
end