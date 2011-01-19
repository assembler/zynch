module AccountsHelper
  
  def dashboard_menu_item(account, title, by)
    content_tag :li, :class => (params[:by] == by ? 'active' : nil) do 
      link_to title, account_path(account, :by => by, :range => params[:range])
    end
  end
  
end
