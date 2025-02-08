class CreateAuctions < ActiveRecord::Migration[7.1]
  def change
    create_table :auctions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :item_name
      t.integer :current_bid
      t.string :status
      t.datetime :end_time

      t.timestamps
    end
  end
end
