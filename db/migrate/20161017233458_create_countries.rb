class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.belongs_to :region, foreign_key: true
    end
  end
end
