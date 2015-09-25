require "google/apis/fitness_v1"

class GooglefitAdapter < BaseAdapter
  ESTIMATED_STEPS_DS =
    "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps"

  class << self
    def required_keys
      %i(token)
    end

    def auth_type
      :oauth
    end

    def website_link
      "https://fit.google.com"
    end

    def title
      "Google Fit"
    end
  end

  def client
    Google::Apis::FitnessV1::FitnessService.new
  end

  def to_nano(timestamp)
    1_000_000_000 * timestamp.to_i
  end

  def fetch_datasource(datasource, days_back)
    now = Time.current.utc
    start = (now - days_back.days).beginning_of_hour
    time_range = [start, now].map(&method(:to_nano)).join("-")
    client.get_user_data_source_dataset(
      "me",
      datasource,
      time_range,
      fields: "point",
      options: { authorization: authorization }
    ).point || []
  end

  def fetch_steps(days_back = 3)
    fetch_datasource(ESTIMATED_STEPS_DS, days_back)
  end

  def authorization
    Signet::OAuth2::Client.new(
      client_id: Rails.application.secrets.google_provider_key,
      client_secret: Rails.application.secrets.google_provider_secret,
      refresh_token: credentials["refresh_token"],
      scope: %w(https://www.googleapis.com/auth/fitness.activity.read),
      token_credential_uri: "https://www.googleapis.com/oauth2/v3/token"
    )
  end
end
