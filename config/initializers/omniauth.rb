Rails.application.config.middleware.use OmniAuth::Builder do
  provider :beeminder,
           Rails.application.secrets.beeminder_provider_key,
           Rails.application.secrets.beeminder_provider_secret

  provider :pocket,
           Rails.application.secrets.pocket_provider_key

  provider :trello,
           Rails.application.secrets.trello_provider_key,
           Rails.application.secrets.trello_provider_secret,
           app_name: "Beemind.me",
           scope: "read",
           expiration: "never"

  provider :google_oauth2,
           Rails.application.secrets.google_provider_key,
           Rails.application.secrets.google_provider_secret,
           scope: %w[
             email
             https://www.googleapis.com/auth/fitness.activity.read
             https://www.googleapis.com/auth/fitness.nutrition.read
             https://www.googleapis.com/auth/fitness.body.read
             https://www.googleapis.com/auth/fitness.blood_glucose.read
             https://www.googleapis.com/auth/fitness.blood_pressure.read
           ].join(","),
           access_type: "offline",
           name: "googlefit",
           prompt: "consent"


end
