source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'

gem 'cpf_cnpj'
gem 'devise_token_auth', github: 'lynndylanhurley/devise_token_auth', branch: 'master'
gem 'rolify'

# gem 'rack-cors'

group :development, :test do
  gem 'awesome_print'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'faker'
  gem 'letter_opener'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 5.0', '>= 5.0.1'
  gem 'rubycritic', require: false
  gem 'sqlite3', '~> 1.4'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 4.5', '>= 4.5.1'
  gem 'simplecov', '~> 0.21.2', require: false
end

group :prodution do
  gem 'pg', '~> 1.1'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
