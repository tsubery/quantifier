# == Schema Information
#
# Table name: users
#
#  beeminder_user_id :string           not null, primary key
#  created_at        :datetime
#  updated_at        :datetime
#

FactoryGirl.define do
  factory :user do
    beeminder_user_id { SecureRandom.hex(8) }
  end
end
