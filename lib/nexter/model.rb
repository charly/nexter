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
        {col: column[0], val: value_of(column[0]), dir: column[1]}
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

    # helper to turn mixed order attributes to a consistant
    def parse(array)
      array.join(",").split(",").map(&:strip).map do |column|
        splits = column.split(" ").map(&:strip).map(&:downcase)
        splits << "asc" if splits.size == 1
        splits
      end
    end
  end
end