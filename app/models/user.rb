class User < ApplicationRecord
  serialize :ip_addresses, JSON
  serialize :geolocations, JSON
  serialize :preferences, JSON

  has_many :connections, dependent: :destroy
  has_many :friends, through: :connections, class_name: 'User'

  belongs_to :region, optional: true
  belongs_to :country, optional: true
  belongs_to :division, optional: true


  validates_presence_of :fb_id, :se_id

  def users
    User.includes(:connections).where(connections: {friend_id: id})
  end
end
