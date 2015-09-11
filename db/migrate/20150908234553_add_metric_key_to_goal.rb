class AddMetricKeyToGoal < ActiveRecord::Migration
  def change
    add_column :goals, :metric_key, :string
    Goal.find_each do |goal|
      p goal.credential_id
      goal.update metric_key: goal.credential.provider.metric_keys.first
    end
    change_column :goals, :metric_key, :string,  null: false
    add_index :goals, :metric_key
  end
end
