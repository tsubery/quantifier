class RemoveBeeminderTokenFromUsersTable < ActiveRecord::Migration
  def change
    User.all.each do |u|
      Credential.create!(
        beeminder_user_id: u.beeminder_user_id,
        provider_name: :beeminder,
        uid: u.beeminder_user_id,
        credentials: {
          "token" => u.beeminder_token
        }
      )
    end
    remove_column :users, :beeminder_token
  end
end
