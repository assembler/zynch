module ApplicationHelper
  
  def seconds_to_time(seconds)
    hours = seconds / (60 * 60)
    seconds = seconds % (60 * 60)
    
    minutes = seconds / 60
    seconds %= 60
    
    "%02d:%02d:%02d" % [hours, minutes, seconds]
  end
  
end
