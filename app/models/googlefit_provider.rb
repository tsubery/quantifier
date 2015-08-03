# == Schema Information
#
# Table name: providers
#
#  id                :integer          not null, primary key
#  beeminder_user_id :string           not null
#  name              :string           not null
#  uid               :string           default(""), not null
#  info              :json             default({}), not null
#  credentials       :json             default({}), not null
#  extra             :json             default({}), not null
#  created_at        :datetime
#  updated_at        :datetime
#

class GooglefitProvider < Provider
  validate :valid_access_token

  def self.sti_name
    "googlefit".freeze
  end

  def oauthable?
    true
  end

  def deltable?
    true
  end

  def client
    GFitness::FitnessService.new
  end

  def calculate_score(options = {})
    return nil unless goal

    points = fetch_new_points
    update_last_fetch_ts(points) if options[:relative]

    points.each_with_object(Hash.new { 0 }) do |point, scores|
      scores[to_hour(point)] += point.value.first.int_val
    end
  end

  private

  def to_hour(point)
    Time.zone.at(point.start_time_nanos.to_i / 1_000_000_000).beginning_of_hour
  end

  def update_last_fetch_ts(points)
    last_modified_time = points.map { |point| point.modified_time_millis.to_i }.max
    goal.params["modified_time_millis"] = last_modified_time if last_modified_time
    goal.save!
  end

  def fetch_new_points
    threshold = goal.params["modified_time_millis"].to_i
    if threshold.zero?
      fetch_points
    else
      fetch_points.select! { |point| threshold < point.modified_time_millis.to_i }
    end
  end

  def fetch_points
    now = Time.current.utc
    time_range = "#{1_000_000_000 * (now.to_i - 1.week).to_i}-#{1_000_000_000 * now.to_i}"
    client.get_user_data_source_dataset(
      "me",
      "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps",
      time_range,
      fields: "point",
      options: { authorization: authorization }
    ).point
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
