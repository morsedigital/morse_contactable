# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'morse_contactable/version'

Gem::Specification.new do |spec|
  spec.name          = "morse_contactable"
  spec.version       = MorseContactable::VERSION
  spec.authors       = ["fredmcgroarty"]
  spec.email         = ["mcfremac@icloud.com"]

  spec.summary       = %q{Module to allow easy contact functions in ActiveRecord models}
  spec.homepage      = "https://github.com/morsedigital/morse_contactable"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "morse_fields_validator","~>1.0"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "guard-rspec", "~> 4.5"
  spec.add_development_dependency "rb-fsevent", "~> 0.9"
  spec.add_development_dependency "shoulda-matchers", "~> 2.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
end
