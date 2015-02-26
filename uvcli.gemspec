# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uvcli/version'

Gem::Specification.new do |spec|
  spec.name          = "uvcli"
  spec.version       = Uvcli::VERSION
  spec.authors       = ["Boy van Amstel"]
  spec.email         = ["boy@dangercove.com"]
  spec.summary       = "UserVoice Command Line Interface."
  spec.description   = "Manage your UserVoice account(s) from the command line."
  spec.homepage      = "https://www.github.com/dangercove/uvcli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'uservoice-ruby', '~> 0.0.11'
end
