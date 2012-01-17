class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from User::NotAdministrator, :with => -> { redirect_to '/' }
  rescue_from User::UnAuthorized, :with => -> { redirect_to '/users/new' }
  rescue_from Group::NotGroupMember, :with => -> { render :text => 'not group member' }
  rescue_from Group::NotGroupOwner, :with => -> { render :text => 'not group owner' }

  private

  before_filter :user
  #helper_method :user

  def user
    @user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
  end

  def login_required
    if session[:user_id]
      @user ||= User.find(session[:user_id])
    else
      session[:redirect_path] = request.path
      raise(User::UnAuthorized)
    end
  end

  def only_group_member(group = nil)
    login_required
    group ||= Group.find(params[:id])
    group.member?(@user) or raise(Group::NotGroupMember)
  end
end
