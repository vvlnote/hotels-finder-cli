#require 'pry'
require_relative "./concerns/findable"

class HotelsFinder::Scraper
	include Findable

	def import_hotels(city_name, check_in_date, check_out_date)
		#puts "inside : list_hotels"
		puts "city = #{city_name}, check_in_date = #{check_in_date}, check_out_date = #{check_out_date}"
		puts "Please wait ..."
		@city_name = city_name
		@check_in_date = check_in_date
		@check_out_date = check_out_date
		url = find_search_url(@city_name, @check_in_date, @check_out_date)
		#puts "#{url}"
		doc = Nokogiri::HTML(open(url))
		doc.css("ol.listings li.hotel").each.with_index(1) do |hotel, i|
			HotelsFinder::Hotel.new(hotel, city_name, check_in_date, check_out_date)
		end
	end

	def import_rooms(room_url)
		Nokogiri::HTML(open(room_url))
	end

end
