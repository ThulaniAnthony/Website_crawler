class CreateCrawlers < ActiveRecord::Migration[7.0]
  def change
    create_table :crawlers do |t|
      t.string :review_text
      t.integer :ratings
      t.date :review_date
      t.string :order_id

      t.timestamps
    end
  end
end
