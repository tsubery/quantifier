class RenameProvidersToCredentials < ActiveRecord::Migration
  def change
    rename_table :providers, :credentials
    rename_column :goals, :provider_id, :credential_id
    rename_column :credentials, :name, :provider_name
  end
end
