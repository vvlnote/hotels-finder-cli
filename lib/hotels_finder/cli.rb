#CLI controller

class HotelsFinder::CLI

	def call 
		puts "Which city do you plan to visit:"
		list_cities
		menu
	end

	def list_cities
		puts <<-DOC.gsub /^\s*/, ''
			1. San Francisco, California, United States of America
			2. Boston, Massachusetts, United States of America
			3. New York, New York, United States of America
		DOC
	end

	def menu
		input = nil
		#while input != "exit" do
			puts "Enter the number of the city you'd like to visit or type list to list the cities or type exit:"
			input = gets.strip.downcase
			case input
			when "1"
				puts "San Francisco"
				check_in_check_out_date("San Francisco")
			when "2"
				puts "Boston"
				check_in_check_out_date("Boston")
			when "3"
				puts "New York"
				check_in_check_out_date("New York")
			when "list"
				list_cities
			when "exit"
				goodbye
			else
				puts "this city is not supported at this time, please enter another number or type list or type exit:"
			end
		#end
	end

	def check_in_check_out_date(city_name)	
		puts "Please enter the check-in date (year-month-day), i.e. 2020-08-05"
		check_in_date = gets.strip
		puts "Please enter the check-out date (year-month-day)"
		check_out_date = gets.strip
		scraper = HotelsFinder::Scraper.new.import_hotels(city_name, check_in_date, check_out_date)
		hotel_menu
	end

	def list_hotel_menu
			puts <<-DOC.gsub /^\s*/, ''
			1. List Hotels with general information
			2. List Hotels with rate
			3. List Hotels with nearby attractions
			4. Information of Hotel rooms
		DOC
	end
	def hotel_menu(input = nil)
		list_hotel_menu
		while input != "exit" && input != "back" do
			puts "Enter the number of info you'd like to see or type list to list this menu or type exit:"
			input = gets.strip.downcase
			case input
			when "1"
				HotelsFinder::Hotel.list_hotels_general_info
			when "2"
				HotelsFinder::Hotel.list_hotels_with_rate
			when "3"
				HotelsFinder::Hotel.list_hotels_with_landmarks
			when "4"
				room_menu
			when "list"
				list_hotel_menu
			when "exit"
				goodbye
				break
			else
				puts "this input is not valid, please enter another number or type list or type exit:"
			end
		end
	end		

	def room_menu
		HotelsFinder::Hotel.list_hotels_name
		input = nil
		while input != "back" do
			puts "Enter the number that you like to check the rooms or type list to list the hotels, or type back to back to hotels info: "
			input = gets.strip.downcase
			if input.to_i > 0 && input.to_i <= HotelsFinder::Hotel.all.length 
				HotelsFinder::Hotel.all[input.to_i - 1].list_rooms
			elsif input == "list"
				HotelsFinder::Hotel.list_hotels_name
			elsif input == "back"
				hotel_menu("back")
				break
			else
				puts "this input is not valid, please enter another number or type list or type exit:"
			end
		end
	end
	def goodbye
		puts "Thank you for using Hotels Finder, see you next time!"
	end

end