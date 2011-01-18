module Param
  def Param.parse(param, method)
    if !param.blank? and param != "-"
      param.send(method)
    else
      nil
    end
  end
end