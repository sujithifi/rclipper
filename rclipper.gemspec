# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rclipper/version'

Gem::Specification.new do |spec|
  spec.name          = "rclipper"
  spec.version       = Rclipper::VERSION
  spec.authors       = ["Sujit"]
  spec.email         = ["sujithifi@gmail.com"]
  spec.summary       = %q{Polygon Clipper}
  spec.description   = %q{Polygon clipping algorithm implemented in Pure Ruby}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `find lib -type f`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 13.0"
end
