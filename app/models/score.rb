# == Schema Information
#
# Table name: scores
#
#  id         :integer          not null, primary key
#  value      :float            not null
#  timestamp  :datetime         not null
#  goal_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  unique     :boolean
#

class Score < ActiveRecord::Base
  belongs_to :goal

  def to_datapoint
    Datapoint.new(
      timestamp: timestamp,
      value: value,
      unique: unique
    )
  end
end
