class WelcomeController < ApplicationController
  
  def index
    render :inline => "Hello from Zynch", :layout => true
  end
  
end