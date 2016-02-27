source "https://rubygems.org"

gem "activerecord-import"
gem "attribute-defaults"
gem "beeminder"
gem "bootstrap-sass"
gem "coffee-rails"
gem "decent_exposure"
gem "draper"
gem "dumper"
gem "haml-rails"
gem "jbuilder"
gem "jquery-rails"
gem "omniauth"
gem "omniauth-oauth2"
gem "pg"
gem "pry-rails"
gem "rails", "~> 4.2.0"
gem "rdiscount"
gem "rollbar"
gem "sass-rails"
gem "schema_plus"
gem "sidekiq"
gem "simple_form"
gem "spring", group: :development
gem "therubyracer", platform: :ruby
gem "uglifier", ">= 1.3.0"
gem "whenever", require: false

# #providers
gem "google-api-client", "0.9"

# The following line avoids deprecation warning when google-api-client is used
gem "representable", "2.3.0"

gem "pocket-ruby"
gem "quizlet-ruby"
gem "ruby-trello"
gem "typeracer_ruby"

# auth
gem "omniauth-beeminder" , github: "tsubery/omniauth-beeminder"
gem "omniauth-google-oauth2"
gem "omniauth-pocket"
gem "omniauth-quizlet", path: "vendor/omniauth-quizlet"
gem "omniauth-trello"

group :development do
  gem "annotate", require: false
  gem "better_errors"
  gem "binding_of_caller", platforms: [:mri_21]
  gem "foreman", require: false
  gem "html2haml"
  gem "hub", require: nil
  gem "quiet_assets"
  gem "rails_layout"
  gem "rb-fchange", require: false
  gem "rb-fsevent", require: false
  gem "rb-inotify", require: false
  gem "rerun", require: false
  gem "rubocop"
end
group :development, :test do
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "jazz_hands", github: "nixme/jazz_hands", branch: "bring-your-own-debugger"
  gem "pry-byebug"
  gem "pry-rescue"
  gem "rspec-rails"
  gem "thin"
end

group :test do
  gem "capybara"
  gem "codeclimate-test-reporter", require: false
  gem "database_cleaner"
  gem "faker"
  gem "launchy"
  gem "poltergeist"
  gem "rspec-instafail", require: false
  gem "timecop"
  gem "vcr"
  gem "webmock"
end
