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
      signature == -1 ? '<' : '>'
    end

    def redirection
      signature == -1 ? 'desc' : 'asc'
    end

    private

    def signature
      DIREC[direction.to_sym] * GOTO[goto]
    end
  end
end

