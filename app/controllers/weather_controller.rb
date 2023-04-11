# app/controllers/weather_controller.rb
class WeatherController < ApplicationController
  def index
  end

  def forecast
    api_key = '23fc32952da3ac8bcddd725fcfff3df6'
    # api_key = Rails.application.credentials.open_weather_map[:api_key]
    service = OpenWeatherMap::Forecast.new(api_key)
    response = service.forecast(params[:city])


    @current = service.current(params[:city])

    @forecast = response.parsed_response['list']

    json_response = response.parsed_response['list']



    # group temperature data by day
    temp_by_day = {}
    json_response.each do |data|
      date = DateTime.parse(data["dt_txt"]).strftime("%Y-%m-%d")
      temp = data["main"]["temp"]
      if temp_by_day[date].nil?
        temp_by_day[date] = [temp]
      else
        temp_by_day[date] << temp
      end
    end

    # find max and min temperature for each day
    temp_stats = {}
    temp_by_day.each do |date, temps|
      temp_stats[date] = {
        max: sprintf("%.2f", temps.max - 273.15),
        min: sprintf("%.2f", temps.min - 273.15)
      }
    end

    @forecast_by_day = temp_stats

    puts @forecast_by_day
    puts '!'*100
    puts @current


    if @forecast.present?
      render :forecast
    else
      render :index
    end
  end

  def current
    # api_key = Rails.application.credentials.open_weather_map[:api_key]
    api_key = '23fc32952da3ac8bcddd725fcfff3df6'
    service = OpenWeatherMap::Current.new(api_key)
    response = service.forecast(params[:city])
    @current = response.parsed_response
    print(@current)

    if @current.present?
      render :current
    else
      render :index
    end
  end

end

