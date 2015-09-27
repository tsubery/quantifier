require "google/apis/fitness_v1"

class GooglefitAdapter < BaseAdapter
  ESTIMATED_STEPS_DS =
    "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps"
  SESSION_ACTIVITY =
    "derived:com.google.activity.segment:com.google.android.gms:session_activity_segment"
  SLEEP_SEGMENT_CODE = 72
  WEIGHT_TRAINING_CODE = 80

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

  def fetch_datasource(datasource, days_back, from = nil)
    from ||= Time.current.utc
    start = (from - days_back.days).beginning_of_day
    time_range = [start, from].map(&method(:to_nano)).join("-")
    client.get_user_data_source_dataset(
      "me",
      datasource,
      time_range,
      # fields: "point",
      options: { authorization: authorization }
    ).point || []
  end

  def fetch_steps(days_back = 2)
    fetch_datasource(ESTIMATED_STEPS_DS, days_back)
  end

  def fetch_sleeps(days_back = 2)
    fetch_segments(SLEEP_SEGMENT_CODE, days_back)
  end

  def fetch_strength(days_back = 2)
    fetch_segments(WEIGHT_TRAINING_CODE, days_back)
  end

  def fetch_segments(activity_code, days_back)
    fetch_datasource(SESSION_ACTIVITY, days_back).select do |point|
      activity_code == point.value.first.int_val
    end
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
