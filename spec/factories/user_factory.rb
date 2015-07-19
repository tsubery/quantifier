# == Schema Information
#
# Table name: users
#
#  beeminder_token   :string           not null
#  beeminder_user_id :string           not null, primary key
#  created_at        :datetime
#  updated_at        :datetime
#

FactoryGirl.define do
  factory :user do
    beeminder_token SecureRandom.hex(16)
    beeminder_user_id SecureRandom.hex(8)
  end
end
