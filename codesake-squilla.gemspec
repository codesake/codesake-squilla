# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'codesake/squilla/version'

Gem::Specification.new do |spec|
  spec.name          = "codesake-squilla"
  spec.version       = Codesake::Squilla::VERSION
  spec.authors       = ["Paolo Perego"]
  spec.email         = ["thesp0nge@gmail.com"]
  spec.description   = %q{Codesake::Dusk::Squilla is a SQL Injection *detection* engine.}
  spec.summary       = %q{Codesake::Dusk::Squilla is a SQL Injection *detection* engine.}
  spec.homepage      = "http://codesake.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "rest-open-uri"
  spec.add_dependency "mechanize"
  spec.add_dependency "logger"
  spec.add_dependency "rainbow"

  spec.add_dependency "codesake-commons", ">= 0.89.0"
end
