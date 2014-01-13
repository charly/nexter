require "bundler/setup"

require "active_support/core_ext"
require "active_support/dependencies"

require "nexter/version"
require "nexter/wrap"
require "nexter/derange"
require "nexter/compass"


module Nexter
  # Your code goes here...

  def self.wrap(relation, model)
    Wrap.new(relation, model)
  end
end
