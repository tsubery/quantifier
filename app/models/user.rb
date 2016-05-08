# == Schema Information
#
# Table name: users
#
#  beeminder_user_id :string           not null, primary key
#  created_at        :datetime
#  updated_at        :datetime
#

class User < ActiveRecord::Base
  has_many :credentials, foreign_key: :beeminder_user_id
  has_many :goals, through: :credentials

  self.primary_key = :beeminder_user_id

  def self.find_by_provider_attrs(attrs)
    User.joins(:providers).find_by(identities: attrs)
  end

  def self.upsert(id, token)
    user = find_or_initialize_by(beeminder_user_id: id)
    user.beeminder_token = token
    user.tap(&:save!)
  end

  def client
    @client ||= BeeminderAdapter.new(beeminder_credentials.credentials).client
  end

  def beeminder_credentials
    credentials.find_by(provider_name: :beeminder)
  end
end
