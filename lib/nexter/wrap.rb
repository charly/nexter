module Nexter
  class Wrap

    # the current model & the scope
    attr_reader :model, :relation

    # extracted values from the relation
    attr_reader :order_values, :associations

    def initialize(relation, model)
      @relation = relation
      @model = model
      @order_values = parse_order( relation.order_values )
      @associations = relation.includes_values
    end

    # TODO : let user determine which strategy to choose:
    # e.g: carousel or stay there
    def next
      after.first
    end

    def previous
      before.first
    end

    def after
      query = Query.new(map_column_values, :next)
      relation.where( query.wheres.join(' OR ') )
    end

    def before
      query = Query.new(map_column_values, :previous)
      relation.where( query.wheres.join(' OR ') ).
              reorder( query.reorders.join(", ") )
    end

    def map_column_values
      @column_values ||= @order_values.map do |column|
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
    def parse_order(array)
      array.join(",").split(",").map(&:strip).map do |column|
        splits = column.split(" ").map(&:strip).map(&:downcase)
        splits << "asc" if splits.size == 1
        splits
      end
    end

  end
end