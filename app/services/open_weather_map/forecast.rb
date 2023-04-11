require 'httparty'

module OpenWeatherMap
  class Forecast
    BASE_URL = 'https://api.openweathermap.org/data/2.5'


    def initialize(api_key)
      @api_key = api_key
    end

    def forecast(city)
      @city = city
      puts "#{BASE_URL}/weather?lat=#{lat}&lon=#{lon}&appid=#{@api_key}"
      HTTParty.get("#{BASE_URL}/forecast?lat=#{lat}&lon=#{lon}&appid=#{@api_key}")
    end

    def current(city)
      @city = city
      HTTParty.get("#{BASE_URL}/weather?lat=#{lat}&lon=#{lon}&appid=#{@api_key}")
    end

    private

    def lat
      geocoded_city_response.first['lat']
    end

    def lon
      geocoded_city_response.first['lon']
    end

    def geocoded_city_response
      @geocoded_city_response ||= Geocode.new(@api_key).geocode(@city)
    end
  end
end
