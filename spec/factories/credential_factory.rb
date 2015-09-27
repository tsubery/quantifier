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

FactoryGirl.define do
  factory :credential do
    user
    provider_name :pocket
    uid { |i| "uid_#{i}" }
    credentials(token: "token")
  end
end
