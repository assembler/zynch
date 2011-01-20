require 'net/http'
require 'uri'

class VisitsController < ApplicationController
  caches_page :script, :if => Proc.new { |c| @ought_cache }
  
  def script
    jscode = render_to_string
    response = Net::HTTP.post_form(URI.parse('http://closure-compiler.appspot.com/compile'), {
      'js_code' => jscode,
      'compilation_level' => "SIMPLE_OPTIMIZATIONS",
      'output_format' => 'text',
      'output_info' => 'compiled_code'
    })
    if response.code.to_s == "200"
      data = response.body
      @ought_cache = true
    else
      data = jscode
      @ought_cache = false
    end
    send_data(data, :type => 'text/javascript; charset=utf-8')
  end
  
  def track
    @account = Account.find(params[:cl].split("-").last.to_i)
    params[:ip] = request.remote_addr
    @new_session, @visit = @account.track(params)
    data = @new_session ? %{ (function () { document.cookie = '__zysid=#{@visit.id};path=/'; })(); } : ''
    send_data(data, :type => 'text/javascript; charset=utf-8')
  end

end
