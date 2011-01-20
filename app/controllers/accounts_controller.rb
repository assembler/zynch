require 'csv'

class AccountsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_account, :only => [ :show, :export, :show_code, :edit, :update, :destroy ]
  
  def index
    @accounts = current_user.accounts
  end
  
  def show
    pages = %w{ browser os screen_resolution major_flash_version country_id language page }
    @partial = 'by_default'
    
    if @account.visits.count.zero?
      flash[:alert] = 'not enough data to generate report'
      redirect_to :action => 'index'
    else
      if params[:range].blank?
        min_date = @account.visits.minimum('created_at')
        max_date = @account.visits.maximum('created_at')
        params[:range] = [min_date, max_date].map { |d| d.to_date.to_s }.join(",")
      end
      @start_date, @end_date = params[:range].split(',').map { |d| d.to_date }

      params[:by] = nil if params[:by].blank?
      
      s = @account.visits
      s = s.where('created_at BETWEEN ? AND ?', @start_date, @end_date) if @start_date != @end_date
      if pages.include?(params[:by])
        @partial = "by_#{params[:by]}"

        case params[:by]
        when 'page'
          @entry_visits = s.count_by('entry_page_id').order('visits DESC').limit(5)
          @exit_visits = s.count_by('exit_page_id').order('visits DESC').limit(5)
        else
          @visits = s.count_by(params[:by])
        end
      else
        s = s.select('YEAR(created_at) AS year, MONTH(created_at) AS month, DAY(created_at) AS day, COUNT(*) AS visits, SUM(pageviews_count) AS hits')
        @visits = s.group('year, month, day').order('year, month, day')
        @monthly_visits = s.group('year, month').order('year, month')
        @visit_duration = s.select('TIME_TO_SEC(TIMEDIFF(updated_at, created_at)) AS duration').group('year, month').order('year, month')
      end
    end
  end
  
  def export
    respond_to do |format|
      format.csv do 
        @visits = @account.visits.includes([:entry_page, :exit_page])
        csv_string = CSV.generate :col_sep => ';' do |csv|
          csv << ['entry', 'exit', *@visits.first.attributes.map { |k, v| k.to_s }]
          @visits.each do |visit|
            csv << [visit.entry_page.path, visit.exit_page.path, *visit.attributes.map { |k, v| v }]
          end
        end
        filename = @account.name.downcase.gsub(/[^0-9a-z]/, "_") + ".csv"
        send_data(csv_string, :type => 'text/csv; charset=utf-8', :filename => filename)
      end
    end
  end
  
  def show_code
  end
  
  def new
    @account = current_user.accounts.build
  end
  
  def create
    @account = current_user.accounts.build(params[:account])
    if @account.save
      flash[:notice] = "Account successfully created!"
      redirect_to show_code_account_url(@account)
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @account.update_attributes(params[:account])
      flash[:notice] = "Account information successfully updated!"
      redirect_to show_code_account_url(@account)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @account.destroy
    redirect_to accounts_url
  end
  
private
  def find_account
    @account = current_user.accounts.find(params[:id])
  end
  
end