require "open-uri"
require 'nokogiri'
#require 'pry'
require_relative "./hotels_finder/version"

#module HotelsFinder
#  class Error < StandardError; end
  # Your code goes here...
#end

require_relative './hotels_finder/cli'
require_relative './hotels_finder/scraper'
require_relative './hotels_finder/hotel'
require_relative './hotels_finder/concerns/findable'
