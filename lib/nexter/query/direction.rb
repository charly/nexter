class Nexter::Query
  class Direction
    attr_reader :column, :compass
    delegate :goto, :bracket, :redirection, to: :compass

    def initialize(column, compass)
      @column = column
      @compass = compass
      compass.direction = column[:dir]
    end

    def slice
      if column[:val].present?
        delimited = "#{column[:col]} #{bracket} '#{column[:val]}'"
        delimited.concat(" OR #{column[:col]} IS NULL") if @compass.sign == 1
        "(#{delimited})"
      elsif @compass.sign == -1
        "#{column[:col]} IS NOT NULL"
      end
    end
    alias sql slice

  end
end

