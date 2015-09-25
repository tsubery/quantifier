# == Schema Information
#
# Table name: providers
#
#  name      :string           not null
#  auth_type :integer          not null
#

FactoryGirl.define do
  factory :credential do
    provider_name :pocket
    uid SecureRandom.hex(8)
    user
  end
end
