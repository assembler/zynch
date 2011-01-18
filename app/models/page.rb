class Page < ActiveRecord::Base
  belongs_to :account
  has_many :pageviews, :dependent => :destroy
  
end