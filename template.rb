
# Base command
# rails --version 8.0.0.beta1 new app --css=tailwind --skip-asset-pipeline --skip-jbuilder --skip-test --skip-action-mailbox --skip-bundle

# Gems
gem 'turbo_power'
gem 'ar_lazy_preload'
gem 'mission_control-jobs'

gem_group :development do
  gem 'hotwire-livereload'
  gem 'rubocop-rspec', require: false
end

gem_group :test do
  gem "rspec-rails"
  gem 'factory_bot_rails'
  gem 'faker'
end

run "bundle install"

rails_command "tailwindcss:install"

run 'rm bin/dev'
run 'rm Procfile.dev'
insert_into_file 'config/puma.rb' do
  "\nplugin :tailwindcss if ENV.fetch(\"RAILS_ENV\", \"development\") == \"development\"\n"
end

run 'cp -r ./daisyui/daisyui*.js lib/daisyui/'

insert_into_file 'config/tailwind.config.js', after: "require('@tailwindcss/container-queries')," do
  "\n    require('@tailwindcss/line-clamp'),\n"
end

# Home page
generate "controller home index"

route "root to: 'home#index'"

# RSpec
generate "rspec:install"


