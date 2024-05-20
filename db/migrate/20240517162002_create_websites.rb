class CreateWebsites < ActiveRecord::Migration[7.1]
  def change
    create_table :websites do |t|
      t.string :url
      t.boolean :restricted
      t.integer :timeout

      t.timestamps
    end
    add_index :websites, :url
  end
end
