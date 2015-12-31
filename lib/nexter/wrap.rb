module Nexter
  class Wrap
    # the current model & the scope
    attr_reader :model, :relation

    def initialize(relation, model)
      @relation = relation
      @model = Model.new(model, relation)
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
      query = Query.new(model.values, :next)
      relation.where( query.wheres.join(' OR ') )
    end

    def before
      query = Query.new(model.values, :previous)
      relation.where( query.wheres.join(' OR ') ).
              reorder( query.reorders.join(", ") )
    end


  end
end