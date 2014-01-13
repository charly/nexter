module Nexter
  class Wrap

    # the current model & the scope
    attr_reader :model, :relation

    # extracted values from the relation
    attr_reader :order_values, :associations

    # list of build strings for finale SQL
    attr_reader :wheres, :reorders


    def initialize(relation, model)
      @relation = relation
      @model = model
      @order_values = arrayize( relation.order_values )
      @associations = relation.includes_values
      # @cursor_column = extract_attr( @ranges.pop )
      # @cursor = model.send( @cursor_column.to_sym, )
    end

    def next
      after.first
    end

    def previous
      before.first
    end

    def after
      derange = cut(:next)
      r = relation.where( wheres.join(' OR ') )
      r = r.order(:id) if derange.reorder
      r
    end

    def before
      cut(:previous)
      relation.where( wheres.join(' OR ') ).reorder( reorders.join(", ") )
    end

  private
    # model.order(a, b,c) loop
    # 1. ( (a and b and c > c.val)
    # 2. (a and b > b.val)
    # 3. (a > a.val))
    def cut(goto = :next)
      order_vals = @order_values.dup
      @wheres = []
      @reorders = []
      derange = Nexter::Derange.new(model, goto)

      while order_col = order_vals.pop do
        derange.set_vals(order_vals, order_col)

        # should be derange's result
        wheres << "( #{derange.trunk} #{derange.slice} )"
        reorders.unshift(" #{derange.delimiter} #{derange.redirection}")
      end

      derange
    end

    # helper to turn mixed order attributes to a consistant
    def arrayize(array)
      array.join(",").split(",").map(&:strip).map do |column|
        splits = column.split(" ").map(&:strip).map(&:downcase)
        splits << "asc" if splits.size == 1
        splits
      end
    end

  end
end