class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: false do |t|
      t.string :beeminder_token, null: false
      t.string :beeminder_user_id, null: false, primary: true, references: nil

      t.timestamps
    end
    add_index :users, :beeminder_user_id, unique: true
  end
end
