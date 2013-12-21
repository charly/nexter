module Nexter
  class Wrap

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
    end

    def next
      after.first || relation.first
    end

    def previous
      before.first || relation.last
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

        inrange_of = order_vals.map {|col| "#{col[0]} = '#{value_of(col[0])}'"}.join(' AND ')
        inrange_of = "#{inrange_of} AND" unless inrange_of.blank?

        direction = order_col[1]
        sign      = signature(direction, goto)

        bigger_than  = "#{order_col[0]} #{get_bracket(sign)} '#{value_of(order_col[0])}'"

        wheres << "( #{inrange_of} #{bigger_than} )"
        reorders.unshift(" #{order_col[0]} #{get_direction(sign)}")
      end
    end

    def signature(dir, goto)
      sign = DIREC[dir.to_sym] * GOTO[goto]
    end

    def get_bracket(sign)
      sign == -1 ? '<' : '>'
    end

    def get_direction(sign)
      sign == -1 ? 'desc' : 'asc'
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