source "https://rubygems.org"

gem "rails", "~> 4.2.0"
gem "sass-rails"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails"
gem "jquery-rails"
gem "jbuilder"
gem "spring", group: :development
gem "bootstrap-sass"
gem "haml-rails"
gem "omniauth"
gem "pg"
gem "simple_form"
gem "therubyracer", platform: :ruby
gem "attribute-defaults"
gem "sidekiq"
gem "beeminder"
gem "decent_exposure"
gem "draper"
gem "whenever", require: false
gem "pry-rails"
gem "schema_plus"
gem "rdiscount"
gem "rollbar"
gem "activerecord-import"

# #providers
gem "google-api-client", "0.9"

# The following line avoids deprecation warning when google-api-client is used
gem "representable", "2.3.0"

gem "ruby-trello"
gem "pocket-ruby"
gem "typeracer_ruby"
gem "quizlet-ruby"

# auth
gem "omniauth-beeminder"
gem "omniauth-pocket"
gem "omniauth-trello"
gem "omniauth-google-oauth2"
gem "omniauth-quizlet", path: "vendor/omniauth-quizlet"

group :development do
  gem "rubocop"
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
  gem "annotate", require: false
  gem "rerun", require: false
end
group :development, :test do
  gem "factory_girl_rails"
  gem "pry-rescue"
  gem "jazz_hands", github: "nixme/jazz_hands", branch: "bring-your-own-debugger"
  gem "pry-byebug"
  gem "rspec-rails"
  gem "dotenv-rails"
  gem "thin"
end

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "faker"
  gem "launchy"
  gem "poltergeist"
  gem "rspec-instafail", require: false
  gem "webmock"
  gem "vcr"
  gem "timecop"
  gem "codeclimate-test-reporter", require: false
end
