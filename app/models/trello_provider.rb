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
  validate :has_access_token
  validate :has_access_secret
  validate :goal_has_board_id, if: "goal"

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

  def calculate_score options={}
    return nil unless goal
    now_utc = Time.now.utc

    board = client.find(:board, board_id)
    total_debt = board.cards.map do |card|
      now_utc - card.last_activity_date
    end.sum

    {
      Time.now.utc => (total_debt/1.day).to_i
    }
  end

  def board_options
    client.find(:member,uid).boards(filter: :open).map do |b|
      [b.name, b.id]
    end
  end

  def goal_has_board_id
    if goal && goal.params["board_id"].nil?
      errors.add(:goal, "missing board_id")
    end
  end

  def board_id
    goal && goal.params["board_id"]
  end

end
