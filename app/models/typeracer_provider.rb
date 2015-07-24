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

class TyperacerProvider < Provider
  validate :valid_uid?, if: "goal.present?"

  def self.sti_name
    "typeracer".freeze
  end

  def oauthable?
    false
  end

  def valid_uid?
    TypeRacer::Client.new(uid)
  rescue TypeRacer::Api::UserNotFound
    errors.add(:uid, "Could not be found in typeracer api!")
  end

  def calculate_score
    return nil if uid.empty?
    TypeRacer::Client.new(uid).completed_games
  end
end
