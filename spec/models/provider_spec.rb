# == Schema Information
#
# Table name: providers
#
#  name      :string           not null
#  auth_type :integer          not null
#

require "rails_helper"

RSpec.describe Provider, type: :model do
  Rails.configuration.provider_names.each do |name|
    xit "can be saved with provider #{name}" do
      expect do
        Provider.new name: name
      end.not_to raise_error
    end
    it "can be saved with provider #{name}" do
      expect do
        p = create :provider,
                   name: name
        Provider.find p.id
      end.not_to raise_error
    end
  end
end
