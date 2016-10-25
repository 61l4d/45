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

  def get_friends(access_token)
    response = Unirest.get "https://graph.facebook.com/#{fb_id}/friends",
               parameters: {
                 access_token: access_token
               }

    # fb error message
    if response.body["error"]
      return render json: {error: {message: response.body["error"]["message"]}}

    # no data section in fb graph
    elsif not response.body["data"]
      return render json: {error: {message: "FB graph response did not contain 'data' section."}}

    # all's well
    else
      friends_array = response.body["data"]

      # get all pages
      while not response.body["next"].nil?
        response = Unirest.get response.body["next"],
                   parameters: {
                     access_token: access_token
                   }
        
        friends_array += response.body["data"] if not response.body["data"].nil?
      end

      friends_array
    end
  end

  def friend_last_updated(friend)
    connection = Connection.find_by(friend_id: friend.id, user_id: id) 

    if not connection.nil?
      connection.last_read_friend_update
    else
      connection = Connection.find_by(friend_id: id, user_id: friend.id)
      connection.last_read_user_update if not connection.nil?
    end
  end

  # returns friends object with last updated time
  def update_connections(fb_friends_arr)
    error_message = "Errors: "
    friends_array = friends + users

    fb_friends_arr.each_with_index do |friend_obj,i|
      friend_listed = friends_array.find{|friend| friend.fb_id == friend_obj["id"]}
      # create connection if none
      if friend_listed.nil? 
        friend = User.find_by(fb_id: friend_obj["id"])

        # cannot find friend in db
        if friend.nil?
          error_message += "Could not find fb friend with id #{friend_obj["id"]} in our records; "

        else
          connection = Connection.new(friend_id: friend.id, user_id: id, last_read_friend_update: Time.now - 1.day, last_read_user_update: Time.now - 1.day)

          # cannot save connection
          if not connection.save
            error_message += "Could not save connection with fb friend with id #{friend_obj["id"]}: #{connection.errors.messages.inspect}; "

          # otherwise, add friend to friends_array
          else 
            friends_array << friend
          end # end error saving connection
        end # end find friend in db
      end # end create connection if none
    end # end fb_friends_arr.each

    {
      friends: friends_array.map do |friend|
                 friend.serialize
                 friend["last_updated"] = friend_last_updated(friend)
               end,
      errors: error_message
    }
  end

  def users
    User.includes(:connections).where(connections: {friend_id: id})
  end

  def ip_addresses=(ip)
    temp = ip_addresses
    temp = {} if temp.nil?

    # ip has been recorded  
    if temp.include?(ip)
      temp[ip].pop if temp[ip].length == 11
      temp[ip].insert(1,Time.now)
      temp[ip][0] += 1
      write_attribute(:ip_addresses,temp)

    else
      # delete the least recorded ip if more than 20 ips
      temp.delete(temp.min_by{|x| x[1][0]}[0]) if temp.length == 1

      # insert new ip
      temp[ip] = [1,Time.now]
    end

    write_attribute(:ip_addresses, temp)
  end

  def geolocations=(geolocation)
    temp = geolocations
    temp = {} if temp.nil?
    key = [geolocation["country"],geolocation["administrative_area_level_1"],geolocation["locality"]].join(";")

    if temp.include?(key)
      temp[key].pop if temp[key].length == 11
      temp[key].insert(1,Time.now)
      temp[key][0] += 1
    else
      # delete the least recorded ip if more than 20 ips
      temp.delete(temp.min_by{|x| x[1][0]}[0]) if temp.length == 1

      # insert new geolocation
      temp[key] = [1,Time.now]
    end

    write_attribute(:geolocations, temp)
  end

  def self.serialize(user)
    {
      fb_id: user.fb_id,
      se_id: user.se_id,
      location: {region: user.region, country: user.country, division: user.division}
    } if not user.nil?
  end
end
