# == Schema Information
#
# Table name: identities
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  provider    :string           not null
#  uid         :string           default(""), not null
#  name        :string           default(""), not null
#  info        :json             default({}), not null
#  credentials :json             default({}), not null
#  extra       :json             default({}), not null
#  created_at  :datetime
#  updated_at  :datetime
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
