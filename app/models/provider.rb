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

  class << self
    def find_sti_class type_name
      ActiveSupport::Dependencies.constantize(type_name.camelize + "Provider")
    end

    def sti_name
      raise NotImplementedError
    end
  end
end
