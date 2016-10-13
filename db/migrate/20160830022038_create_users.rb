class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|

			t.string :fb_id
      t.string :se_id
      t.text :ip_addresses
      t.text :preferences

      t.timestamps
    end
  end
end
