class Account < ActiveRecord::Base
  belongs_to :user
  has_many :visits, :dependent => :destroy
  has_many :pages, :dependent => :destroy
  
  validates :name, :presence => true
  validates :domain, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true
  
  def code
    "ZY-#{'%010d' % self.id}"
  end
  
  def track(params)
    path = ::Param::parse(params[:pn], :to_s)
    page = nil
    unless path.nil?
      page = self.pages.find_or_create_by_path(path)
      page.host = ::Param::parse(params[:hn], :to_s)
      page.search = ::Param::parse(params[:ss], :to_s)
      page.charset = ::Param::parse(params[:cs], :to_s)
      page.title = ::Param::parse(params[:pt], :to_s)
      page.save
    end
    
    visit = self.visits.find_by_id ::Param::parse(params[:id], :to_i)
    new_session = false
    if visit.nil? # new session
      new_session = true
      visit = self.visits.build
      visit.ip_address = params[:ip]
      visit.update_attributes_from_params(params)
      
      location = ::Geo.resolve(visit.ip_address)
      if !location.nil? and location.country_code
        country = Country.find_or_create_by_id(location.country_code)
        country.name = location.country_name
        country.save
        visit.country = country
      end
    end
      
    visit.entry_page = page if visit.entry_page.nil?
    visit.exit_page = page
    visit.save
    
    pageview = visit.pageviews.build
    pageview.page = page
    pageview.save
    
    [new_session, visit]
  end
  
end