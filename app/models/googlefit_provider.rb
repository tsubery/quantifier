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
  validate :has_access_token

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

  def calculate_score options={}
    return nil unless goal
    now = Time.now.utc
    time_range = "#{1_000_000_000*(now.to_i-1.week).to_i}-#{1_000_000_000*now.to_i}"

    points = client.get_user_data_source_dataset(
      'me',
      'derived:com.google.step_count.delta:com.google.android.gms:estimated_steps',
      time_range,
      fields: 'point',
      options: { authorization: authorization }
    ).point
    unless (threshold = goal.params['modified_time_millis'].to_i).zero?
      points.select! { |point| threshold < point.modified_time_millis.to_i }
    end

    if options[:relative]
      last_modified_time = points.map{ |point| point.modified_time_millis.to_i }.max
      goal.params['modified_time_millis'] = last_modified_time if last_modified_time
      goal.save!
    end

    scores = {}
    points.each do |point|
      ts = Time.at(point.start_time_nanos.to_i/1_000_000_000).beginning_of_day
      scores[ts] ||= 0
      scores[ts] += point.value.first.int_val
    end
    scores
  end

  private

  def authorization
    Signet::OAuth2::Client.new(
    client_id: Rails.application.secrets.google_provider_key,
    client_secret: Rails.application.secrets.google_provider_secret,
    refresh_token: Provider.last.credentials['refresh_token'],
    scope: %w(https://www.googleapis.com/auth/fitness.activity.read),
    token_credential_uri: 'https://www.googleapis.com/oauth2/v3/token'
  )
  end
end
