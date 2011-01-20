class Account < Thor
  
  desc "sample_for", "creates test account and fills it with sample data"
  method_option :count, :default => 100, :aliases => '-c', :desc => 'how many visits you want to generate'
  method_option :environment, :default => 'development', :aliases => '-e', :desc => 'which environment you want server run'
  
  def sample_for(email)
    puts "initializing..."
    ENV["RAILS_ENV"] = options[:environment]
    
    require './config/environment'
    account_name = 'ZynchTestAccount'.freeze
    
    user = User.find_by_email(email)
    if user.nil?
      puts "unknown user"
      return
    end
    
    account = user.accounts.find_or_create_by_name(account_name)
    account.domain = 'http://localhost/'
    account.first_name = 'Test'
    account.last_name = 'Test'
    account.email = email
    account.save
    
    pages = [
      { :pn => '/zynch-test/index.html', :pt => 'zynch-test' },
      { :pn => '/zynch-test/index2.html', :pt => 'zynch-test 2' },
      { :pn => '/zynch-test/index3.html', :pt => 'zynch-test 3' },
      { :pn => '/zynch-test/index4.html', :pt => 'zynch-test 4' },
      { :pn => '/zynch-test/index5.html', :pt => 'zynch-test 5' }
    ]
    
    browsers = %w{ Chrome Safari Firefox Opera }
    
    resolutions = [
      { :sw => 1920, :sh => 1200 },
      { :sw => 1280, :sh => 960 },
      { :sw => 1024, :sh => 768 },
      { :sw => 800, :sh => 600 }
    ]
    
    countries = [
      Country.find_or_create_by_id_and_name('GB', 'United Kingdom'),
      Country.find_or_create_by_id_and_name('ME', 'Montenegro'),
      Country.find_or_create_by_id_and_name('BE', 'Belgium'),
      Country.find_or_create_by_id_and_name('GR', 'Greece')
    ]
    
    puts "generating #{options[:count]} records, please wait..."
    options[:count].to_i.times do |i|
      id = (rand() > 0.2) ? account.visits.last.try(:id) : nil
      
      page = pages.sample
      browser = browsers.sample
      browser_version = (rand() * 6).round + 2
      resolution = resolutions.sample
      flash_version = (rand() > 0.2) ? 10 : 9
      os = (rand() > 0.2) ? 'Win' : 'Mac'
      
      params = {
       :id => id,
       :cl => account.code,
       :hn => "localhost",
       :pn => page[:pn],
       :ss => "",
       :pt => page[:pt],
       :sw => resolution[:sw],
       :sh => resolution[:sh],
       :cd => 24,
       :fv => "#{flash_version}.1.103",
       :la => "en-US",
       :je => "1",
       :cs => "UTF-8",
       :br => browser,
       :bv => browser_version,
       :os => os
      }
      
      account.track(params)
    end
    
    puts "randomizing dates and countries"
    account.visits.each do |visit|
      created = (rand() * 60).ceil.days.ago
      updated = created + (rand() * 60).ceil.minutes
      visit.country = countries.sample
      visit.save
      visit.update_attribute :created_at, created
      visit.update_attribute :updated_at, updated
    end
  end

private

end