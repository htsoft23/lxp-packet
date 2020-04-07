# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lxp/version'

Gem::Specification.new do |s|
  s.name          = 'lxp-packet'
  s.version       = LXP::VERSION
  s.authors       = ['Chris Elsworth']
  s.email         = ['chris@cae.me.uk']

  s.summary       = 'Library to generate and parse LuxPower inverter packets'
  s.homepage      = 'https://github.com/celsworth/lxp-packet'
  s.license       = 'MIT'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/celsworth/lxp-packet'

  s.files         = `git ls-files -z`.split("\x0")
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'rspec'
end
