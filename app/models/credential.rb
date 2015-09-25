# == Schema Information
#
# Table name: credentials
#
#  id                :integer          not null, primary key
#  beeminder_user_id :string           not null
#  provider_name     :string           not null
#  uid               :string           default(""), not null
#  info              :json             default({}), not null
#  credentials       :json             default({}), not null
#  extra             :json             default({}), not null
#  created_at        :datetime
#  updated_at        :datetime
#

class Credential < ActiveRecord::Base
  validates :uid, :user, presence: true

  belongs_to :user, primary_key: :beeminder_user_id, foreign_key: :beeminder_user_id
  has_many :goals, dependent: :destroy

  def client
    authorization = credentials.merge(uid: uid).with_indifferent_access
    provider.adapter.new(authorization)
  end

  def provider
    ProviderRepo.find!(provider_name)
  end

  def access_token
    credentials.fetch "token"
  end

  def valid_access_token
    errors.add(:credentials, "missing token key") unless credentials["token"]
  end

  def access_secret
    credentials.fetch "secret"
  end

  def valid_access_secret
    errors.add(:credentials, "missing token key") unless credentials["token"]
  end

end
