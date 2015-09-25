# == Schema Information
#
# Table name: goals
#
#  id            :integer          not null, primary key
#  credential_id :integer          not null
#  slug          :string           not null
#  last_value    :float
#  params        :json             default({}), not null
#  metric_key    :string           not null
#

class Goal < ActiveRecord::Base
  belongs_to :credential
  has_many :scores, dependent: :destroy
  has_one :user, through: :credential

  delegate :provider, to: :credential

  validates :slug, presence: :true

  def metric
    provider.find_metric(metric_key)
  end

  def sync
    calculated = fetch_scores
    stored = scores.map(&:to_datapoint)
    new_datapoints = (calculated - stored)

    send_datapoints new_datapoints
    store_scores new_datapoints
  end

  def fetch_scores
    Array(metric.call(credential.client, options))
  end

  def store_scores(datapoints)
    scores.delete_all
    columns = %i(goal_id datapoint_id timestamp value)
    score_records = datapoints.map do |datapoint|
      [id, datapoint.id, datapoint.timestamp, datapoint.value]
    end

    Score.import columns, score_records
  end

  def send_datapoints(scores)
    return if scores.empty?
    beeminder_goal.add scores.map(&:to_beeminder)
  end

  def beeminder_goal
    user.client.goal(slug)
  end

  private

  def options
    params.symbolize_keys
  end
end
