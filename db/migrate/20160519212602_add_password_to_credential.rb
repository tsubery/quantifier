class AddPasswordToCredential < ActiveRecord::Migration[5.0]
  def change
    add_column :credentials, :password, :string, null: false, default: ""
  end
end
