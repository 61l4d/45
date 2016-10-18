class CreateDivisions < ActiveRecord::Migration[5.0]
  def change
    create_table :divisions do |t|
      t.string :name
      t.belongs_to :country, foreign_key: true
    end
  end
end
