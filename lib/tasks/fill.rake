require 'net/http'
require 'uri'

namespace :visits do
  
  desc "Fills visits with sample data"
  task :fill => [:environment] do 
    account = Account.find(1)
    
    pages = [
      { :pn => '%2Fzynch-test%2Findex.html', :pt => 'zynch-test' },
      { :pn => '%2Fzynch-test%2Findex2.html', :pt => 'zynch-test%202' },
      { :pn => '%2Fzynch-test%2Findex3.html', :pt => 'zynch-test%203' },
      { :pn => '%2Fzynch-test%2Findex4.html', :pt => 'zynch-test%204' },
      { :pn => '%2Fzynch-test%2Findex5.html', :pt => 'zynch-test%205' }
    ]
    
    browsers = %w{ Chrome Safari Firefox Opera }
    
    resolutions = [
      { :sw => 1920, :sh => 1200 },
      { :sw => 1280, :sh => 960 },
      { :sw => 1024, :sh => 768 },
      { :sw => 800, :sh => 600 }
    ]
    
    1000.times do |i|
      id = (rand() > 0.2) ? account.visits.last.try(:id) : nil
      
      page = pages.sample
      browser = browsers.sample
      browser_version = (rand() * 6).round + 2
      resolution = resolutions.sample
      flash_version = (rand() > 0.2) ? 10 : 9
      os = (rand() > 0.2) ? 'Win' : 'Mac'
            
      url = "http://localhost:3000/track?id=#{id}&cl=#{account.code}"
      url<< "&hn=localhost"
      url<< "&pn=#{page[:pn]}"
      url<< "&ss="
      url<< "&pt=#{page[:pt]}"
      url<< "&sw=#{resolution[:sw]}"
      url<< "&sh=#{resolution[:sh]}"
      url<< "&cd=24"
      url<< "&fv=#{flash_version}.1.103"
      url<< "&la=en-US"
      url<< "&je=1"
      url<< "&cs=UTF-8"
      url<< "&br=#{browser}"
      url<< "&bv=#{browser_version}"
      url<< "&os=#{os}"
      
      uri = URI.parse(url)
      res = Net::HTTP.start(uri.host, uri.port) { |http| http.get(uri.request_uri) }
    end
  end
  
  task :randomize_dates => [:environment] do 
    account = Account.find(1)
    
    account.visits.each do |visit|
      created = (rand() * 60).ceil.days.ago
      updated = created + (rand() * 60).ceil.minutes
      
      visit.update_attribute :created_at, created
      visit.update_attribute :updated_at, updated
    end
  end
  
  task :randomize_countries => [:environment] do 
    account = Account.find(1)
    
    countries = [
      Country.find_or_create_by_id_and_name('GB', 'United Kingdom'),
      Country.find_or_create_by_id_and_name('ME', 'Montenegro'),
      Country.find_or_create_by_id_and_name('BE', 'Belgium'),
      Country.find_or_create_by_id_and_name('GR', 'Greece')
    ]
    
    account.visits.each do |visit|
      visit.country = countries.sample
      visit.save
    end
  end
  
end