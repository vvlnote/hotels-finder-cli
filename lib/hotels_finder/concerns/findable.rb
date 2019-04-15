module Findable


	def find_search_url (city_name, check_in_date, check_out_date)
			city_urls = {
			"New York" => {
				:check_in_date => "",
				:check_out_date => "",
				:url => "https://www.hotels.com/search.do?resolved-location=CITY%3A1506246%3AUNKNOWN%3AUNKNOWN&destination-id=1506246&q-destination=New%20York,%20New%20York,%20United%20States%20Of%20America&q-check-in=#{check_in_date}&q-check-out=#{check_out_date}&q-rooms=1&q-room-0-adults=2&q-room-0-children=0"
				},
			"San Francisco" => {
				:check_in_date => "",
				:check_out_date => "",
				:url => "https://www.hotels.com/search.do?resolved-location=CITY%3A1493604%3AUNKNOWN%3AUNKNOWN&destination-id=1493604&q-destination=San%20Francisco,%20California,%20United%20States%20of%20America&q-check-in=#{check_in_date}&q-check-out=#{check_out_date}&q-rooms=1&q-room-0-adults=2&q-room-0-children=0"			
			},
			"Boston" => {
				:check_in_date => "",
				:check_out_data => "",
				:url => "https://www.hotels.com/search.do?resolved-location=CITY%3A1401516%3AUNKNOWN%3AUNKNOWN&destination-id=1401516&q-destination=Boston,%20Massachusetts,%20United%20States%20of%20America&q-check-in=#{check_in_date}&q-check-out=#{check_out_date}&q-rooms=1&q-room-0-adults=2&q-room-0-children=0"
			}
		}

		city_urls[city_name][:check_in_date] = check_in_date
		city_urls[city_name][:check_out_date] = check_out_date
		#puts "#{city_urls[city_name][:check_in_date]}, #{city_urls[city_name][:check_out_date]}"
		city_urls[city_name][:url]
	end

end