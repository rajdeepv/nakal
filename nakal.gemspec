# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nakal/version'

Gem::Specification.new do |spec|
  spec.name          = "nakal"
  spec.version       = Nakal::VERSION
  spec.authors       = ["Rajdeep"]
  spec.email         = ["mail.rajvarma@gmail.com"]
  spec.summary       = "Automated visual regression testing of android and ios apps with appium , calabash or any other driver"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/rajdeepv/nakal"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rmagick', "~>2.15.2"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
