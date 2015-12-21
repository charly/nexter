require "bundler/setup"

require "active_support/all"
# require "active_support/dependencies"

require "nexter/version"
require "nexter/wrap"
require "nexter/query"
require "nexter/query/section"
require "nexter/query/direction"

require "nexter/compass"
require "nexter/eyecontact"


module Nexter
  # Your code goes here...

  def self.wrap(relation, model)
    Wrap.new(relation, model)
  end
end
