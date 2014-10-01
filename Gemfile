source 'https://rubygems.org'
ruby '2.1.3'

gem 'rails', '~> 4.1.6'
gem 'pg'

gem 'devise'
gem 'activeadmin', github: 'activeadmin'

gem 'font-awesome-rails', '~> 4.2.0.0'
gem 'bootstrap-sass', '~> 3.2.0.2'
gem 'bootstrap-validator-rails'
gem 'sass-rails', '~> 4.0.3'
gem 'autoprefixer-rails'
gem 'coffee-rails', '~> 4.0.1'
gem 'uglifier', '>= 2.5.3'

group :development do
    # Console
  gem 'pry-rails'
  gem 'hirb-unicode'
  gem 'awesome_print'

  gem 'capistrano', '~> 2.15.5'
  gem 'rvm-capistrano'
  gem 'capistrano_colors'
  gem 'capistrano-unicorn', :require => false

  # Very useful gem (used with Google Chrome extention 'Rails Panel'). Read more: https://github.com/dejan/rails_panel
  gem 'meta_request', '~> 0.3.4'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :production do
  gem 'rails_12factor'
end

gem 'delayed_job_active_record', '~> 4.0.1'

gem 'unicorn', '~> 4.8.3'
