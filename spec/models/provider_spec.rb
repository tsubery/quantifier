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

require 'rails_helper'

RSpec.describe Provider, :type => :model do
  Rails.configuration.provider_names.each do |name|
    xit "can be saved with provider #{name}" do
      expect {
        Provider.new name: name
      }.not_to raise_error
    end
    it "can be saved with provider #{name}" do
      expect {
        p = create :provider,
        name: name
        Provider.find p.id
      }.not_to raise_error
    end
  end
end
