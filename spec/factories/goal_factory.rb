# == Schema Information
#
# Table name: goals
#
#  id            :integer          not null, primary key
#  credential_id :integer          not null
#  slug          :string           not null
#  last_value    :float
#  params        :json             not null
#  metric_key    :string           not null
#  active        :boolean          default(TRUE), not null
#  fail_count    :integer          default(0), not null
#

FactoryGirl.define do
  factory :goal do
    slug { |i| "slug_#{i}" }
    metric_key :article_days_linear
    credential
  end
end
