class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :beeminder_user_id, null: false, references: nil
      t.string :name, null: false
      t.string :uid, default: "", null: false
      t.json :info, default: "{}", null: false
      t.json :credentials, default: "{}", null: false
      t.json :extra, default: "{}", null: false
      t.timestamps
    end
    add_foreign_key :providers, :users, column: :beeminder_user_id, primary_key: :beeminder_user_id
    add_index :providers, [:name, :uid], unique: true
    add_index :providers, [:name, :beeminder_user_id], unique: true
  end
end
