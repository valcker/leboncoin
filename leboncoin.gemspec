# encoding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'leboncoin'
  spec.version       = '0.1.2'
  spec.authors       = ['Roman Le Négrate']
  spec.email         = ['roman.lenegrate@gmail.com']
  spec.summary       = %q{Leboncoin results parser and Atom feed generator}
  spec.homepage      = 'https://github.com/Roman2K/leboncoin'
  spec.license       = 'Unlicense'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'vcr', '~> 2.8.0'

  spec.add_dependency 'faraday', '~> 0.8.8'
  spec.add_dependency 'nokogiri', '~> 1.6.1'
end
