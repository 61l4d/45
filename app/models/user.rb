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

  def ip_addresses=(ip)
    temp = ip_addresses
    temp = {} if temp.nil?

    # ip has been recorded  
    if ip_addresses.include?(ip)
      temp[ip].pop if temp[ip].length == 11
      temp[ip].insert(1,Time.now)
      temp[ip][0] += 1
      write_attribute(:ip_addresses,temp)

    else
    # delete the least recorded ip if more than 20 ips
      temp.delete(temp.min_by{|x| x[1][0]}[0]) if ip_addresses.length == 1

    # insert new ip
      temp[ip] = [1,Time.now]
    end

    write_attribute(:ip_addresses, temp)
  end

  def geolocations=(geolocation)
    temp = geolocations
    temp = [] if temp.nil?
    temp.pop if temp.length == 20
    temp.unshift([geolocation,Time.now])

    write_attribute(:geolocations, temp)
  end
end
