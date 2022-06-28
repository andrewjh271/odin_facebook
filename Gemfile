source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.4', '>= 5.4.3'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11', '>= 2.11.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.12', require: false

gem 'devise', '~> 4.8', '>= 4.8.1'
gem 'faker', '~> 2.1'
gem 'figaro', '~> 1.2'

gem 'active_record_union', '~> 1.3'

gem 'cloudinary', '~> 1.23'

# Use Active Storage variant
gem 'image_processing', '~> 1.12', '>= 1.12.2'

gem 'omniauth-facebook', '~> 8.0'
gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-rails', '~> 5.1', '>= 5.1.2'
  gem 'factory_bot_rails', '~> 6.2'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0'

  gem 'better_errors', '~> 2.9', '>= 2.9.1'
  gem 'binding_of_caller', '~> 1.0'
  gem 'annotate', '~> 3.2'

  gem 'letter_opener', '~> 1.8', '>= 1.8.1'

  gem 'guard', '~> 2.18'
  gem 'guard-rspec', '~> 4.7', '>= 4.7.3', require: false
  gem 'spring-commands-rspec', '~> 1.0', '>= 1.0.4'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.37', '>= 3.37.1'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  gem 'launchy', '~> 2.5'
  gem 'shoulda-matchers', '~> 5.1'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
