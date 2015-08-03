Rails.application.config.middleware.use OmniAuth::Builder do
  provider :beeminder,
           Rails.application.secrets.beeminder_provider_key,
           Rails.application.secrets.beeminder_provider_secret

  provider :pocket,
           Rails.application.secrets.pocket_provider_key

  provider :trello,
           ENV["TRELLO_PROVIDER_KEY"],
           ENV["TRELLO_PROVIDER_SECRET"],
           app_name: "Beemind.me",
           scope: "read",
           expiration: "never"

  provider :google_oauth2,
           Rails.application.secrets.google_provider_key,
           Rails.application.secrets.google_provider_secret,
           scope: "email, https://www.googleapis.com/auth/fitness.activity.read",
           access_type: "offline",
           name: "googlefit",
           prompt: "consent"
end
