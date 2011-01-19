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
  
end