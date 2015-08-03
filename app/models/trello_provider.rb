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

class TrelloProvider < Provider
  validate :valid_access_token
  validate :valid_access_secret
  validate :goal_has_list_ids, if: "goal"

  def self.sti_name
    "trello".freeze
  end

  def oauthable?
    true
  end

  def deltable?
    false
  end

  def client
    Trello::Client.new(
      consumer_key: Rails.application.secrets.trello_provider_key,
      consumer_secret: Rails.application.secrets.trello_provider_key,
      oauth_token: access_token,
      oauth_token_secret: access_secret
    )
  end

  def total_debt
    now_utc = Time.current.utc
    goal.params["list_ids"].flat_map do |list_id|
      client.find(:list, list_id).cards.map(&:itself)
    end.map do |card|
      now_utc - card.last_activity_date
    end.sum
  end

  def calculate_score(_options = {})
    return nil unless goal
    {
      Time.current.utc => (total_debt / 1.day).to_i
    }
  end

  def list_options
    client.find(:member, uid).boards(filter: :open).flat_map do |b|
      b.lists.map do |l|
        joined_name = [b.name, l.name].join("/")
        [joined_name, l.id]
      end
    end
  end

  def goal_has_list_ids
    return if goal && goal.params["list_ids"]
    errors.add(:goal, "missing list_ids")
  end

  def list_ids
    goal && goal.params["list_ids"]
  end
end
