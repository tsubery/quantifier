# frozen_string_literal: true
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

  def fetch_datasource(datasource, from = nil)
    client.get_user_data_source_dataset(
      "me", datasource,
      time_range(from),
      options: { authorization: authorization }
    ).point || []
  rescue Signet::AuthorizationError
    raise AuthorizationError
  end

  def fetch_steps(from = nil)
    fetch_datasource(ESTIMATED_STEPS_DS, from)
  end

  def fetch_sleeps(from)
    # for sleeps tz matters so we mandate from arg
    fetch_segments(SLEEP_SEGMENT_CODE, from)
  end

  def fetch_strength(from = nil)
    fetch_segments(WEIGHT_TRAINING_CODE, from)
  end

  def fetch_segments(activity_code, days_back)
    fetch_datasource(SESSION_ACTIVITY, days_back).select do |point|
      activity_code == point.value.first.int_val
    end
  end

  private

  def time_range(from = nil)
    now ||= Time.current.utc
    from ||= (now - 2.days).beginning_of_day
    "#{to_nano(from)}-#{to_nano(now)}"
  end

  def to_nano(timestamp)
    1_000_000_000 * timestamp.to_i
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
