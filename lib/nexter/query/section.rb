class Nexter::Query

  # Iterates over the columns, extracts their values
  # and builds query part that says :
  #
  # > "col1 = value1"
  # > "col2 = value2"
  #
  # then joins them with AND :
  #
  # > "col1 = value1 AND col2 = value2"
  #
  class Section
    attr_reader :columns, :compass

    # TODO : check if compass is needed (don't think so!)
    def initialize(columns)
      @columns = columns
      @compass = compass
    end

    def iterate
      @where ||= columns.map do |column|
        if column[:val]
          "#{column[:col]} = #{quote(column[:val])}"
        else
          "#{column[:col]} IS NULL"
        end
      end.join(' AND ')
    end
    alias sql iterate

    def blank?
      iterate.blank?
    end

    private
    def quote(value)
      if value.is_a?(Integer)
        value
      # TODO: lookat numeric precision e.g.
      #   round(vat::numeric, 2) = 19.66;
      elsif value.is_a?(Float)
        value
      else #value.is_a?(String)
        "'#{value.gsub("'", "")}'"
      end
    end


  end #section
end