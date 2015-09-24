class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.float :value, null: false
      t.datetime :timestamp, null: false
      t.string :datapoint_id, foreign_key: false
      t.references :goal, index: true, foreign_key: true
      t.timestamps
    end
    add_index :scores, [:goal_id, :timestamp], unique: true
  end
end
