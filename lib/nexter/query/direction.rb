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
        delimited = "#{column[:col]} #{bracket} #{quote(column[:val])}"
        delimited.concat(" OR #{column[:col]} IS NULL") if @compass.sign == 1
        "(#{delimited})"
      elsif @compass.sign == -1
        "#{column[:col]} IS NOT NULL"
      end
    end
    alias sql slice

    private
    def quote(value)
      if value.is_a?(Float)
        @compass.sign == 1 ? value + 0.0001 : value - 0.0001
      elsif value.is_a?(Integer)
        value
      elsif value.is_a?(String)
        "'#{value.gsub("'", "")}'"
      else #value.is_a?(String)
        "'#{value}'"
      end
    end



  end
end

