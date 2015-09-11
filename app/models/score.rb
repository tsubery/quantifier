# == Schema Information
#
# Table name: scores
#
#  id           :integer          not null, primary key
#  value        :float            not null
#  timestamp    :datetime         not null
#  datapoint_id :string
#  goal_id      :integer
#

class Score < ActiveRecord::Base
  belongs_to :goal

  def to_datapoint
    Datapoint.new id: datapoint_id,
                  timestamp: timestamp,
                  value: value
  end
end
