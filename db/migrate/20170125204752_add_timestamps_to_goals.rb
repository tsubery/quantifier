class AddTimestampsToGoals < ActiveRecord::Migration[5.0]
  def change
    add_column :goals, :created_at, :datetime
    add_column :goals, :updated_at, :datetime
  end
end
