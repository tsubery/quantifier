class AddStatusFlagToGoal < ActiveRecord::Migration
  def change
    add_column :goals, :active, :boolean, default: true, null: false
    add_column :goals, :fail_count, :integer, default: 0, null: false
  end
end
