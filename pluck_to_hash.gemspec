# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pluck_to_hash/version'

Gem::Specification.new do |spec|
  spec.name          = 'pluck_to_hash'
  spec.version       = PluckToHash::VERSION
  spec.authors       = ['Girish S', 'Gerjan Stokkink']
  spec.email         = ['girish.sonawane@gmail.com', 'gerjan@bookingexperts.nl']

  spec.summary       = 'Extend ActiveRecord and Array pluck to return hash'
  spec.description   = 'Extend ActiveRecord and Array pluck to return hash instead of an array. Useful when plucking multiple columns/keys.'
  spec.homepage      = 'https://github.com/bookingexperts/pluck_to_hash'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'no public push allowed'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '~> 5.0'
  spec.add_dependency 'activesupport', '~> 5.0'
end
