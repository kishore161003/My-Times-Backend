class CreateWebsiteVisits < ActiveRecord::Migration[7.1]
  def change
    create_table :website_visits do |t|
      t.references :website, null: false, foreign_key: true
      t.date :visit_date
      t.integer :time_spent

      t.timestamps
    end
  end
end
