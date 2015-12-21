module Nexter
  #
  #
  #
  class Compass

    attr_accessor :goto, :direction

    DIREC  = {asc: 1, desc: -1}
    GOTO = {next: 1, previous: -1}

    def initialize(goto)
      @goto = goto
    end

    def bracket
      sign == -1 ? '<' : '>'
    end

    def redirection
      sign == -1 ? 'DESC' : 'ASC'
    end

    def sign
      DIREC[direction.downcase.to_sym] * GOTO[goto]
    end
  end
end

