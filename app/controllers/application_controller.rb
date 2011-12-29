class ApplicationController < ActionController::Base
  protect_from_forgery

  def user
    name = session[:name]
    name and User.find_by_name(name)
  end
end
