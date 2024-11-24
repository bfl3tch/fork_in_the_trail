source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'devise'
gem 'dotenv-rails'
gem 'faraday'
gem 'fast_jsonapi'
gem "rails", "~> 7.0.8", ">= 7.0.8.6"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem "byebug"
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
  gem "simplecov"
  gem "shoulda-matchers"
end

group :test do
  gem "webmock", '~> 3.18'
end


