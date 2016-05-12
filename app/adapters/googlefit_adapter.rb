# frozen_string_literal: true
require "google/apis/fitness_v1"

class GooglefitAdapter < BaseAdapter
  ESTIMATED_STEPS_DS =
    "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps"
  ACTIVITY_SEGMENT = "com.google.activity.segment"
  SLEEP_SEGMENT_CODES = [ 72, 109, 110, 111, 112]
  INACTIVE_SEGMENT_CODES = [ 0, 1, 2, 3, 4 ] + SLEEP_SEGMENT_CODES
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

  def fetch_active(from = nil)
    fetch_segments(from) do |activity_id|
      INACTIVE_SEGMENT_CODES.exclude?(activity_id)
    end
  end

  def fetch_sleeps(from)
    # for sleeps tz matters so we mandate from arg
    fetch_segments(from) do |activity_id|
      SLEEP_SEGMENT_CODES.include?(activity_id)
    end
  end

  def fetch_strength(from = nil)
    fetch_segments(from) do |activity_id|
      activity_id == WEIGHT_TRAINING_CODE
    end
  end

  def fetch_segments(from)
    by = Google::Apis::FitnessV1::AggregateBy.new(data_type_name: ACTIVITY_SEGMENT)
    client.aggregate_dataset(
      "me",
      Google::Apis::FitnessV1::AggregateRequest.new(
        aggregate_by: [by],
        bucket_by_activity_segment: true,
        start_time_millis: (from || default_from).to_i*1000,
        end_time_millis: UTC.now.to_i*1000),
        options: {authorization: authorization}
    ).bucket.map do |bucket|
      bucket.dataset.first.point.first
    end.select do |point|
      block_given? ? yield(point.value.first.int_val) : true
    end
  end

  private

  def time_range(from = nil)
    "#{to_nano(from || default_from)}-#{to_nano(UTC.now)}"
  end

  def default_from
    (UTC.now - 2.days).beginning_of_day
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
