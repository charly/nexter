# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nexter/version'

Gem::Specification.new do |spec|
  spec.name          = "nexter"
  spec.version       = Nexter::VERSION
  spec.authors       = ["Charles Sistovaris"]
  spec.email         = ["charlysisto@gmail.com"]
  spec.description   = %q{What is Nexter ? A misspelled tv show or a killer feature ? Almost : it wraps your model with an ordered scope and cuts out the next and previous record. It also works with associations & nested columns.}
  spec.summary       = %q{Wrap your model with an ordered scope and cut out the _next_ and _previous_ record.}
  spec.homepage      = "https://github.com/charly/nexter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_dependency "activerecord", "~> 3.2"
  spec.add_dependency "activesupport", "~> 3.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"


end
