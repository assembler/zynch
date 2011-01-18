class AccountsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_account, :only => [ :show, :show_code, :edit, :update, :destroy ]
  
  
  def index
    @accounts = current_user.accounts
  end
  
  def show
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