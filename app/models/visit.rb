class Visit < ActiveRecord::Base
  scope :count_by, lambda { |field| select("#{field}, COUNT(*) AS visits").group("#{field}") }
  
  belongs_to :account
  belongs_to :country
  has_many :pageviews, :dependent => :destroy
  belongs_to :entry_page, :foreign_key => 'entry_page_id', :class_name => 'Page'
  belongs_to :exit_page, :foreign_key => 'exit_page_id', :class_name => 'Page'
  
  def update_attributes_from_params(params)
    self.screen_width = ::Param::parse(params[:sw], :to_i)
    self.screen_height = ::Param::parse(params[:sh], :to_i)
    self.screen_resolution = "#{self.screen_width}x#{self.screen_height}" unless self.screen_width.nil? or self.screen_height.nil?
    self.color_depth = ::Param::parse(params[:cd], :to_i)
    self.flash_version = ::Param::parse(params[:fv], :to_s)
    self.major_flash_version = self.flash_version.split(".").first unless self.flash_version.nil?
    self.language = ::Param::parse(params[:la], :to_s).downcase
    self.java_enabled = ::Param::parse(params[:je], :to_i).zero? ? false : true
    self.browser = ::Param::parse(params[:br], :to_s).downcase
    self.browser_version = ::Param::parse(params[:bv], :to_s)
    self.os = ::Param::parse(params[:os], :to_s).downcase
  end

end