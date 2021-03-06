# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mordor/version'

Gem::Specification.new do |spec|
  spec.name          = "mordorpm"
  spec.version       = Mordor::VERSION
  spec.authors       = ["ArchimedesPi"]
  spec.email         = ["archimedespi3141@gmail.com"]
  spec.summary       = %q{Small package-manager for Linux and OpenWRT}
  spec.description   = %q{Mordor is a package manager for Linux (including embedded systems). Mordor is designed to operate using Git to fetch packages.}
  spec.homepage      = "http://archimedespi.github.io/mordor"
  spec.license       = "BSD"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"

  spec.add_dependency "thor"
  spec.add_dependency "term-ansicolor"
  spec.add_dependency "multi_json"
  spec.add_dependency "oj"
  spec.add_dependency "git"
end
