FactoryGirl.define do
  factory :provider do
    name :pocket
    uid SecureRandom.hex(8)
    user
  end
end
