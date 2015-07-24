class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.references :provider, null: false
      t.string :slug, null: false
      t.float :last_value
    end
    add_index :goals, [:slug, :provider_id], unique: true
  end
end
