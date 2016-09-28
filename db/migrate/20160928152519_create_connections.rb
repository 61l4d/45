class CreateConnections < ActiveRecord::Migration[5.0]
  def change
    create_table :connections do |t|
      t.integer :user_id, null: false
      t.integer :friend_id, null: false

      t.datetime :last_read_friend_update
      t.datetime :last_read_user_update

      t.timestamps
    end
  end
end
