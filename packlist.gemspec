# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'packlist/version'

Gem::Specification.new do |spec|
  spec.name          = "packlist"
  spec.version       = Packlist::VERSION
  spec.authors       = ["Jim Cushing"]
  spec.email         = ["jimothy@mac.com"]

  spec.summary       = "Create gear lists for your next backpacking adventure."
  spec.description   = "Create gear lists for your next backpacking adventure."
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'sass'
  spec.add_dependency 'sinatra'
  spec.add_dependency 'padrino-helpers', '~> 0.13.2'

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "coveralls", "~> 0.8"
end
