require 'open-uri'
require 'ostruct'

module Geo
  def Geo.resolve(ip_address)
    doc = Nokogiri::HTML(open("http://www.geoplugin.net/xml.gp?ip=#{ip_address.to_s}"))
    location = OpenStruct.new
    location.city = doc.css('geoplugin_city').first.content
    location.region = doc.css('geoplugin_region').first.content
    location.country_code = doc.css('geoplugin_countrycode').first.content
    location.country_name = doc.css('geoplugin_countryname').first.content
    location.continent_code = doc.css('geoplugin_continentcode').first.content
    location
  rescue
    nil
  end  
end