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

class Provider < ActiveRecord::Base
  self.inheritance_column = :name

  validates_inclusion_of :name, in: Rails.configuration.provider_names
  validates_presence_of :uid, :user

  belongs_to :user, primary_key: :beeminder_user_id, foreign_key: :beeminder_user_id
  has_one :goal, dependent: :destroy
  accepts_nested_attributes_for :goal

  class << self
    def new attrs = {}
      if attrs.has_key?(:name)
        name = attrs.delete(:name)
        find_sti_class(name).new attrs
      else
        super
      end
    end
    def find_sti_class type_name
      ActiveSupport::Dependencies.constantize(type_name.camelize + "Provider")
    end

    def sti_name
      raise NotImplementedError
    end
  end

  def oauthable?
    raise NotImplementedError
  end

  def missing_oauth?
    credentials.empty? && oauthable?
  end

  def goal_slug
    return nil if goal.nil?
    goal.slug
  end

  def access_token
    credentials.fetch "token"
  end

  def has_access_token
    unless credentials["token"]
      errors.add(:credentials, "missing token key")
    end
  end

  def access_secret
    credentials.fetch "secret"
  end

  def has_access_secret
    unless credentials["token"]
      errors.add(:credentials, "missing token key")
    end
  end

end
