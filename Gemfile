source "https://rubygems.org"

gemspec

group :test do
  gem "rake", "~> 10.0.0"
  gem "rspec", "~> 2.11.0"
  gem "cucumber", "~> 1.2.0"
  gem "haml", "~> 3.1.7"
  gem "sass"
  gem "compass"
  gem "RedCloth"
  
  # Last version of redcarpet compatible with ruby 1.8.7 is 2.3.0
  gem "redcarpet", "#{(RUBY_VERSION == '1.8.7') ? '2.3.0' : '~> 3.0.0' }"

  if tilt_version = ENV["TILT_VERSION"]
    gem "tilt", tilt_version
  end
end
