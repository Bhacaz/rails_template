
# Base command
# rails new app --template template.rb --css=tailwind --javascript=importmap --skip-jbuilder --skip-test --skip-action-mailbox --skip-kamal

# ==== Gems
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
# require 'debug'
# debugger
run "bundle install"

# ==== TurboPower

run './bin/importmap pin turbo_power'

# ==== Tailwind CSS
# Will only use puma plugin in development
run 'rm bin/dev'
run 'rm Procfile.dev'
insert_into_file 'config/puma.rb' do
  "\nplugin :tailwindcss if ENV.fetch(\"RAILS_ENV\", \"development\") == \"development\"\n"
end

# ==== DaisyUI
require 'net/http'
response = Net::HTTP.get_response(
  URI.parse('https://raw.githubusercontent.com/Bhacaz/rails_template/refs/heads/main/daisyui-4.12.13.js')
)

empty_directory 'lib/daisyui'
File.write('./lib/daisyui/daisyui.js', response.body)

insert_into_file 'config/tailwind.config.js', after: "require('@tailwindcss/container-queries')," do
  "\n    require('../lib/daisyui/daisyui'),"
end

insert_into_file 'config/tailwind.config.js', before: /^}/ do
  <<~JS
      ,
      daisyui: {
        themes: ["night"],
        darkTheme: "night",
      },
  JS
end

gsub_file 'app/views/layouts/application.html.erb', '<html>', '<html data-theme="night">'

# ==== Home page
generate "controller home index --skip-helper"

run 'rm app/views/home/index.html.erb'
file 'app/views/home/index.html.erb', <<~CODE
<div class="hero">
  <div class="hero-content text-center">
    <div class="max-w-md">
      <h1 class="text-5xl font-bold">#{app_name.camelize}</h1>
      <p class="py-6">
        Rails <%= Rails::VERSION::STRING %>
      </p>
      <p class="py-6">
        Generated with <a class="link link-hover font-bold" href=https://github.com/Bhacaz/rails_template>github.com/Bhacaz/rails_template</a>
      </p>
      <button class="btn btn-primary">Get Started</button>
    </div>
  </div>
</div>
CODE

route "root to: 'home#index'"

# ==== Hotwire Livereload
# Skip tasks installation to avoid installing Redis
content = <<~HTML
    \n    <%= hotwire_livereload_tags if Rails.env.development? %>
  HTML
insert_into_file 'app/views/layouts/application.html.erb', content.chop, before: /\s*<\/head>/

gsub_file 'app/views/layouts/application.html.erb',
          '<%= stylesheet_link_tag "app", "data-turbo-track": "reload" %>',
          '<%= stylesheet_link_tag "app", "data-turbo-track": Rails.env.development? ? "reload" : "" %>'

# ==== SolidQueue development

# insert_into_file 'config/environments/development.rb', after: "config.active_job.verbose_enqueue_logs = true\n" do
#   "  config.active_job.queue_adapter = :solid_queue
#    config.solid_queue.connects_to = { database: { writing: :queue } }"
# end

# RSpec
# generate "rspec:install"


