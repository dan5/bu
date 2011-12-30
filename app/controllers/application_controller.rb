class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :user

  def user
    name = session[:name]
    @user = (name && User.find_by_name(name))
  end
end
