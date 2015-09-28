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
#  active        :boolean          default(TRUE), not null
#  fail_count    :integer          default(0), not null
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
    stored = scores.order(:timestamp).map(&:to_datapoint)
    syncher = DatapointsSync.new(calculated, stored, beeminder_goal).call
    store_scores syncher.storable
  end

  def fetch_scores
    Array(metric.call(credential.client, options))
  end

  def store_scores(datapoints)
    return if datapoints.empty?
    scores.delete_all
    columns = %i(goal_id unique timestamp value)
    score_records = datapoints.map do |datapoint|
      [id,
       datapoint.unique,
       datapoint.timestamp || Time.zone.now,
       datapoint.value]
    end

    Score.import columns, score_records
  end

  def beeminder_goal
    user.client.goal(slug)
  end

  def options
    params.with_indifferent_access
  end
end
