# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout

module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { page_title.to_s }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:stylesheets) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:javascripts) { javascript_include_tag(*args) }
  end
  
  def flash_messages
    messages = []
    messages << content_tag(:p, notice, :class=>'flash_message notice') if notice
    messages << content_tag(:p, alert,  :class=>'flash_message alert')  if alert
    messages.join.html_safe
  end
end