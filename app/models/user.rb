class User < ApplicationRecord
  serialize :ip_addresses, JSON
  serialize :preferences, JSON

  has_many :connections, dependent: :destroy
  has_many :friends, through: :connections, class_name: 'User'

  def users
    User.includes(:connections).where(connections: {friend_id: id})
  end
end
