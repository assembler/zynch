class VisitsController < ApplicationController

  def new
    @account = Account.find(params[:cl].split("-").last.to_i)

    path = ::Param::parse(params[:pn], :to_s)
    page = nil
    unless path.nil?
      page = @account.pages.find_or_create_by_path(::Param::parse(params[:pn], :to_s))
      page.host = ::Param::parse(params[:hn], :to_s)
      page.search = ::Param::parse(params[:ss], :to_s)
      page.charset = ::Param::parse(params[:cs], :to_s)
      page.title = ::Param::parse(params[:pt], :to_s)
      page.save
    end
    
    @visit = @account.visits.find_by_id ::Param::parse(params[:id], :to_i)
    @new_session = false
    if @visit.nil? # new session
      @new_session = true
      @visit = @account.visits.build
      @visit.ip_address = request.remote_addr
      @visit.update_attributes_from_params(params)
      
      location = ::Geo.resolve(@visit.ip_address)
      if !location.nil? and location.country_code
        country = Country.find_or_create_by_id(location.country_code)
        country.name = location.country_name
        country.save
        @visit.country = country
      end
    end
    
    @visit.save
    
    pageview = @visit.pageviews.build
    pageview.page = page
    pageview.save
    
    @visit.entry_pageview = pageview if @visit.entry_pageview.nil?
    @visit.exit_pageview = pageview
    @visit.save    
  end

end
