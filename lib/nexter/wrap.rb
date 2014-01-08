module Nexter
  class Wrap

    # the gui concatenating strings
    attr_reader :derange

    # the current model & the scope
    attr_reader :model, :relation

    # extracted values from the relation
    attr_reader :order_values, :associations

    # list of build strings for finale SQL
    attr_reader :wheres, :reorders

    DIREC  = {asc: 1, desc: -1}
    GOTO = {next: 1, previous: -1}

    def initialize(relation, model)
      @relation = relation
      @model = model
      @order_values = arrayize( relation.order_values )
      @associations = relation.includes_values
      # @cursor_column = extract_attr( @ranges.pop )
      # @cursor = model.send( @cursor_column.to_sym, )
      @derange = Nexter::Derange.new(model)
    end

    def next
      after.first
    end

    def previous
      before.first
    end


    def after
      cut(:next)
      relation.where( wheres.join(' OR ') )
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

      while order_col = order_vals.pop do

        derange.columns = order_vals
        derange.delimiter = order_col[0]
        derange.direction = order_col[1]
        derange.sign      = signature(derange.direction, goto)

        wheres << "( #{derange.trunk} #{derange.bigger_than} )"
        reorders.unshift(" #{order_col[0]} #{get_direction(derange.sign)}")
      end
    end

    def signature(dir, goto)
      sign = DIREC[dir.to_sym] * GOTO[goto]
    end

    def get_direction(sign)
      sign == -1 ? 'desc' : 'asc'
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