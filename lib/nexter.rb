require "bundler/setup"

require "active_support/core_ext"

require "nexter/version"
require "nexter/wrap"


module Nexter
  # Your code goes here...

  def self.wrap(relation, model)
    Wrap.new(relation, model)
  end
end
