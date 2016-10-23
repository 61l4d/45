class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|

			t.string :fb_id
      t.string :se_id
      t.text :ip_addresses
      t.text :geolocations
      t.text :preferences
      t.belongs_to :region, foreign_key: true
      t.belongs_to :country, foreign_key: true
      t.belongs_to :division, foreign_key: true

      t.timestamps
    end
  end
end
