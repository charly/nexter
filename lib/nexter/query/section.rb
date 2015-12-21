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
          "#{column[:col]} = '#{column[:val]}'"
        else
          "#{column[:col]} IS NULL"
        end
      end.join(' AND ')
    end
    alias sql iterate

    def blank?
      iterate.blank?
    end

  end #section
end