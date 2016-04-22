# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'motive_record/version'

Gem::Specification.new do |spec|
  spec.name          = 'motive_record'
  spec.version       = MotiveRecord::VERSION
  spec.authors       = ['kayhide']
  spec.email         = ['kayhide@gmail.com']

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = 'https://github.com/kayhide/motive_record'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'motion_blender'
  spec.add_runtime_dependency 'motive_support'
  spec.add_runtime_dependency 'motive_model'
  spec.add_runtime_dependency 'motion-securerandom'
  spec.add_runtime_dependency 'activerecord', '= 4.2.5'
  spec.add_runtime_dependency 'motion.h'
  spec.add_runtime_dependency 'sqlite3'
  spec.add_development_dependency 'bundler', '>= 1.10'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'motion-redgreen'
  spec.add_development_dependency 'motion-stump'
  spec.add_development_dependency 'motion_print'
end
