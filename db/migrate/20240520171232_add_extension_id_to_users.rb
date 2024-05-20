class AddExtensionIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :extension_id, :string
  end
end
