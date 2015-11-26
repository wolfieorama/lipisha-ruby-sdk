# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lipisha/sdk/version'

Gem::Specification.new do |spec|
  spec.name          = "lipisha-sdk"
  spec.version       = Lipisha::Sdk::VERSION
  spec.authors       = ["Lipisha Consortium Limited"]
  spec.email         = ["api@lipisha.com"]
  spec.description   = %q{Lipisha Payments Ruby SDK.}
  spec.summary       = %q{Lipisha Payments Ruby SDK}
  spec.homepage      = "https://github.com/lipisha/lipisha-ruby-sdk"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
end
