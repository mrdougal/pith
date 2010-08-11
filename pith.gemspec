$: << File.expand_path("../lib", __FILE__)
require "pith/version"

Gem::Specification.new do |gem|

  gem.name = "pith"
  gem.summary = "A static website generator"
  gem.homepage = "http://github.com/mdub/pith"
  gem.authors = ["Mike Williams"]
  gem.email = "mdub@dogbiscuit.org"

  gem.version = Pith::VERSION
  gem.platform = Gem::Platform::RUBY
  gem.add_runtime_dependency("tilt", "~> 0.9")

  gem.require_path = "lib"
  gem.files = Dir["lib/**/*", "samples/**/*", "README.markdown", "LICENSE"]
  gem.test_files = Dir["Rakefile", "spec/**/*", "features/**/*", "cucumber.yml"]

end