# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'goods/version'

Gem::Specification.new do |spec|
  spec.name          = "goods"
  spec.version       = Goods::VERSION
  spec.authors       = ["Artem Pyanykh"]
  spec.email         = ["artem.pyanykh@gmail.com"]
  spec.description   = <<DESC
  The purpose of this gem is to provide simple, yet reliable solution for parsing
  YML (Yandex Market Language) files, with clean and convenient interface,
  and extra capabilites, such as categories prunning.
DESC
  spec.summary       = %q{Simple parser for YML (Yandex Market Language) files with a few twists.}
  spec.homepage      = "https://github.com/ArtemPyanykh/goods"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0.beta1"

  spec.add_runtime_dependency "libxml-ruby"
  spec.add_runtime_dependency "nokogiri"
end
