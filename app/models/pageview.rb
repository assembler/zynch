class Pageview < ActiveRecord::Base
  belongs_to :page
  belongs_to :visit, :counter_cache => true
  
end