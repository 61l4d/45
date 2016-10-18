class Region < ApplicationRecord
  has_many :countries
  has_many :divisions, through: :countries
  has_many :users
end
