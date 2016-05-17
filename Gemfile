source "https://rubygems.org"

gem "activerecord-import"
gem "beeminder"
gem "bootstrap-sass"

# needed in order to support draper on rails5
gem "activemodel-serializers-xml",
    git: "https://github.com/rails/activemodel-serializers-xml"
gem "draper", github: "janraasch/draper"
gem "haml-rails"
gem "jquery-rails"
gem "omniauth"
gem "omniauth-oauth2"
gem "pg"
gem "pg_drive"
gem "pry-rails"
gem "rails", "5.0.0.rc1"
gem "rollbar"
gem "sass-rails"
gem "sidekiq"
gem "simple_form"
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
gem "omniauth-beeminder", branch: "master", github: "beeminder/omniauth-beeminder"
gem "omniauth-google-oauth2"
gem "omniauth-pocket"
gem "omniauth-quizlet", path: "vendor/omniauth-quizlet"
gem "omniauth-trello"

group :development do
  gem "annotate", require: false
  gem "better_errors"
  gem "brakeman", require: false
  gem "binding_of_caller", platforms: [:mri_21]
  gem "html2haml"
  gem "hub", require: false
  gem "quiet_assets"
  gem "rails_layout"
  gem "rb-fchange", require: false
  gem "rb-fsevent", require: false
  gem "rb-inotify", require: false
  gem "rerun", require: false
  gem "rubocop", require: false
  gem "spring"
end

group :development, :test do
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "jazz_hands", github: "nixme/jazz_hands", branch: "bring-your-own-debugger"
  gem "pry-byebug"
  gem "pry-rescue"
  gem "rspec-rails"
  gem "thin"
  gem "spring-commands-rspec"
end

group :test do
  gem "capybara"
  gem "codeclimate-test-reporter", require: false
  gem "poltergeist"
  gem "rspec-instafail", require: false
  gem "timecop"
  gem "vcr"
  gem "webmock"
end
