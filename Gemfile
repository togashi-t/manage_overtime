source "https://rubygems.org"
git_source(:github) {|repo| "https://github.com/#{repo}.git" }

ruby "2.6.2"
gem "bootsnap", ">= 1.1.0", require: false
gem "puma", "~> 3.11"
gem "rails", "~> 5.2.3"
gem "sass-rails", "~> 5.0"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"

gem "devise"

gem "devise-i18n"
gem "rails-i18n", "~> 5.1"

gem "bootstrap", "~> 4.4.1"
gem "devise-bootstrap-views", "~> 1.0"
gem "jquery-rails"

gem "chart-js-rails"
gem "flatpickr"
gem "gon"

gem "faker"
gem "gimei"
gem "tod"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "factory_bot_rails"
  gem "mysql2", ">= 0.4.4", "< 0.6.0"
  gem "pry-byebug"
  gem "pry-doc"
  gem "pry-rails"
  gem "rspec-rails"
  gem "rubocop-rails"
  gem "rubocop-rspec"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :production do
  gem "pg"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
