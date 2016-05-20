# == Schema Information
#
# Table name: credentials
#
#  id                :integer          not null, primary key
#  beeminder_user_id :string           not null
#  provider_name     :string           not null
#  uid               :string           default(""), not null
#  info              :json             not null
#  credentials       :json             not null
#  extra             :json             not null
#  created_at        :datetime
#  updated_at        :datetime
#  password          :string           default(""), not null
#

FactoryGirl.define do
  factory :credential do
    user
    provider_name :pocket
    uid { |i| "uid_#{i}" }
    credentials(token: "token")
  end
end
