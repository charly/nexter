module Nexter
  class Query
    attr_reader :columns, :compass, :wheres, :reorders

    def initialize(columns, goto)
      @columns = columns
      @compass = Compass.new(goto)
      @reorders = []
      iterate
    end

    def iterate
      @wheres = []
      columns = @columns.dup

      while column = columns.pop do
        section   = Section.new(columns)
        direction = Direction.new(column, compass)

        reorders.unshift("#{column[:col]} #{direction.compass.redirection}")

        next unless direction.slice

        @wheres << "#{section.sql}#{section.blank? ? '' : ' AND '}#{direction.sql}"
      end

      # binding.pry
      @wheres.compact!
    end

    alias sql iterate




  end
end
