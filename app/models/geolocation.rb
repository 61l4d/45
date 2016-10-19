class Geolocation
  def self.country_state_locality_from_google_hash(h)
    my_location = {}
    num_set = 0

    h["results"].each do |location|
      break if num_set > 2

      location["address_components"].each do |component|
        if not my_location.include?(:country) and component["types"].include?("country")
          my_location[:country] = component["long_name"]
          num_set += 1
        end

        if not my_location.include?(:administrative_area_level_1) and component["types"].include?("administrative_area_level_1")
          my_location[:administrative_area_level_1] = component["long_name"]
          num_set += 1
        end

        if not my_location.include?(:locality) and component["types"].include?("locality")
          my_location[:locality] = component["long_name"]
          num_set += 1
        end
      end
    end

    my_location
  end
end
