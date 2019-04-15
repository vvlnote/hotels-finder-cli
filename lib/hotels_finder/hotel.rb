require_relative "./concerns/findable"

class HotelsFinder::Hotel
	#extend Findable::ClassMethods
	@@all = []
	attr_accessor :check_in, :check_out, :hotel_url, :contact, :deal_price, :price, :availability, :rating, :star, 
	:name, :is_available, :has_deal, :unavailable_description, :rate_description, :rate, 
	:land_marks, :star, :rooms

	def initialize(info_doc, city_name, check_in_date, check_out_date)
		@@all << self
		@rooms = []
		@name = info_doc.css("h3.p-name a").text
		@city_name = city_name
		@check_in = check_in_date
		@check_out = check_out_date
		@hotel_url = "https://www.hotels.com" + info_doc.css("h3.p-name a")[0]["href"]
		@contact = info_doc.css("address.contact span").text
		@deal_price = info_doc.css("article section.hotel-wrap aside.pricing div.price a ins").text
		@is_available = true
		@unavailable_description = ''
		if @deal_price == ""
			@has_deal = false
			@unavailable_description = info_doc.css("p.sold-out-message").text
			if @unavailable_description != ""
				@is_available = false
			else
				@price = info_doc.css("div.price a strong").text

			end
		else
			@has_deal = true

		end
		@rate_description = info_doc.css("div.reviews-box strong").text
		@rate = @rate_description.split(' ')[-1]
		@land_marks = []
		if info_doc.css('ul.property-landmarks li').length > 0 
			info_doc.css('ul.property-landmarks li').each do |item|
				@land_marks << item.text
			end
		end
		@deal_items = []
		if info_doc.css('aside.pricing ul.deals li.deals-item').length > 0
		 	info_doc.css('aside.pricing ul.deals li.deals-item').each do |item|
				@deal_items << item.text
			end
		end
		import_rooms

	end

	def import_rooms
		doc = HotelsFinder::Scraper.new.import_rooms(hotel_url)
		#nearby attraction
		doc.css('div#overview-section-6 ul li').each do |item|
			land_marks << item.text
		end
		@star =  doc.css('div.property-description div.vcard span.star-rating-text span.widget-tooltip-bd').text		

		doc.css('ul.rooms li.room').each.with_index(0) do |info, i|

			obj = {}
			obj[:room] = info.css('div.room-info div.room-images-and-info h3 span.room-name').text
			obj[:occupancy] = info.css('div.occupancy').text
			prices = info.css('div.price ins.current-price').text
			#obj[:price] = info.css('div.price ins.current-price').text

			prices += info.css('div.price strong.current-price').text
			prices = prices.lstrip.rstrip#remove all the white spaces
			price_arr = prices.split('$') 
			price_arr.shift #remove the first emty item

			if info.css('div.cancellation').length > 0
				obj[:options] = []
				option_obj = {}
				info.css('div.cancellation').each.with_index(0) do |option, i|
					option_obj = {}
					option_obj[:cancellation] = option.css('strong.widget-tooltip').text
					
					option_obj[:cancellation_detail] = option.css('span.widget-tooltip-bd').text
					option_obj[:price] = "$#{price_arr[i]}"
					obj[:options] << option_obj
				end
			end
			if info.css('ul.rateplan-features li').length > 0
				obj[:features] =[]
				info.css('ul.rateplan-features li').each.with_index(0) do |feature, i|
					obj[:features] << feature.text
				end
			end
			rooms << obj
		end
	end

	def self.all
		@@all
	end

	def self.list_hotels_general_info
		all.each.with_index(1) do |hotel, i|
			str = "#{i}. #{hotel.name} - "
			if hotel.is_available == false
				str += "#{hotel.unavailable_description}"
			elsif hotel.has_deal == true
				str += "#{hotel.deal_price}"
			else
				str += "#{hotel.price}"
			end
			
			puts "#{str} -- #{hotel.star}"
			puts "   #{hotel.contact}"
		end
	end

	def self.list_hotels_with_rate
		all.each.with_index(1) do |hotel, i|
			puts "#{i}. #{hotel.name} - rating #{hotel.rate_description}"
		end
	end
	def self.list_hotels_with_landmarks
		all.each.with_index(1) do |hotel, i|
			puts "#{i}. #{hotel.name} - nearby attractions:"
			hotel.land_marks.each do |land_mark|
				puts "   " + land_mark
			end
		end
	end

	def self.list_hotels_name
		all.each.with_index(1) do |hotel, i|
			puts "#{i}. #{hotel.name}"
		end
	end

	def list_rooms
		puts "#{name}"
		rooms.each.with_index(1) do |room, i|
			puts "#{room[:room]} :#{room[:occupancy].downcase} "
			room[:options].each.with_index(0) do |option, i|
				puts "------------------------------------------------------------------------"
				puts "    -#{option[:price]}/night"
				puts "    -#{option[:cancellation]}"
				puts "    -feature: #{room[:features][i]}"
			end
			puts "************************************************************************"
			puts
		end
	end

end
