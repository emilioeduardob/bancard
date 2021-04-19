require_relative "lib/bancard/version"

Gem::Specification.new do |spec|
  spec.name        = "bancard"
  spec.version     = Bancard::VERSION
  spec.authors     = ["Emilio Blanco"]
  spec.email       = ["emilioeduardob@gmail.com"]
  spec.homepage    = "http://www.dotech.com.py"
  spec.summary     = "Engine para gateway bancard"
  spec.description = "Bancard VPOS"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.1.3", ">= 6.1.3.1"
  spec.add_dependency "http", "~> 4.4.1"
end
