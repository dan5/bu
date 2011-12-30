class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :user

  private

  def user
    name = session[:name]
    @user = (name && User.find_by_name(name))
  end

  def only_group_member(group)
    only_logged_user or return(false)
    if group.member?(@user)
      return true
    else
      redirect_to group
      return false
    end
  end

  def only_logged_user
    if @user
      return true
    else
      redirect_to '/users/new'
      return false
    end
  end
end
