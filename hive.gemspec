
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hive/version"

Gem::Specification.new do |spec|
  spec.name          = "hive"
  spec.version       = Hive::VERSION
  spec.authors       = ["juanma"]
  spec.email         = ["jrodulfo@zinio.com"]

  spec.summary       = "workers + sagas"
  spec.description   = "workers + sagas"
  spec.homepage      = "https://www.zinio.com"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://www.zinio.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'redis', '~> 4.0'

  spec.add_dependency 'activesupport', '~> 5.2'
  spec.add_dependency 'bunny', '~> 2.9'
  spec.add_dependency 'hashie', '~> 3.5'
  spec.add_dependency 'resque', '~> 1.27'
end
