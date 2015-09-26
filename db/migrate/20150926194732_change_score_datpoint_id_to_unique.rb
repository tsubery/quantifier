class ChangeScoreDatpointIdToUnique < ActiveRecord::Migration
  def change
    add_column :scores, :unique, :boolean
    Score.update_all(unique: false)
    Score.where.not(datapoint_id: nil).update_all(unique: true)
    remove_column :scores, :datapoint_id
    change_column_null :scores, :unique, true
  end
end
