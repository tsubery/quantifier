class AddParamsToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :params, :json, default: {}, null: false
  end
end
