# -*- encoding: utf-8 -*-
require File.expand_path('../lib/acts_as_hashed/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rodrigo Pinto"]
  gem.email         = ["rodrigopqn@gmail.com"]
  gem.description   = %q{ActsAsHashed is helpful to set a hash_code column based on SecureRandom.hex(16).}
  gem.summary       = %q{SecureRandom hex generator for hashed_code column.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "acts_as_hashed"
  gem.require_paths = ["lib"]
  gem.version       = ActsAsHashed::VERSION

  gem.add_development_dependency "rspec",   '2.11.0'
  gem.add_development_dependency "sqlite3"

  gem.add_dependency "activerecord",        '>= 3.0.0'
end
