lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_social/version'

Gem::Specification.new do |spec|
  spec.platform    = Gem::Platform::RUBY
  spec.name        = "spree_social"
  spec.version     = SpreeSocial.version
  spec.summary     = "Adds social network login services (OAuth) to Spree"
  spec.description = spec.summary
  spec.required_ruby_version = ">= 2.1.0"

  spec.author   = "John Dyer"
  spec.email    = "jdyer@spreecommerce.com"
  spec.homepage = "http://www.spreecommerce.com"
  spec.license  = "BSD-3"

  spec.files        = `git ls-files`.split("\n")
  spec.test_files   = `git ls-files -- spec/*`.split("\n")
  spec.require_path = "lib"
  spec.requirements << "none"

  spec.add_runtime_dependency "spree_core", "~> 3.0.4"
  spec.add_runtime_dependency "spree_auth_devise"
  spec.add_runtime_dependency "omniauth"
  spec.add_runtime_dependency "oa-core"
  spec.add_runtime_dependency "omniauth-wonderful-union"

  spec.add_development_dependency "capybara", "~> 2.4"
  spec.add_development_dependency "climate_control", "~> 0.0"
  spec.add_development_dependency "coffee-rails", "~> 4.0.0"
  spec.add_development_dependency "database_cleaner", "1.4.0"
  spec.add_development_dependency "factory_girl", "~> 4.4"
  spec.add_development_dependency "ffaker"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "poltergeist", "~> 1.6.0"
  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "rspec-rails", "~> 3.2.0"
  spec.add_development_dependency "rubocop", ">= 0.24.1"
  spec.add_development_dependency "sass-rails", "~> 5.0.0"
  spec.add_development_dependency "selenium-webdriver", ">= 2.44.0"
  spec.add_development_dependency "simplecov", "~> 0.9.0"
  spec.add_development_dependency "sqlite3", "~> 1.3.10"
end
