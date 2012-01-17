class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :user

  rescue_from User::NotAdministrator, :with => -> { redirect_to '/' }
  rescue_from User::UnAuthorized, :with => -> { redirect_to '/users/new' }
  rescue_from Group::NotGroupMember, :with => -> { render :text => 'not group member' }
  rescue_from Group::NotGroupOwner, :with => -> { render :text => 'not group owner' }

  # thx: http://d.hatena.ne.jp/kaorumori/20111113/1321155791
  protect_from_forgery

  def login_required
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    else
      redirect_to root_path
    end
  end

  private

  #helper_method :user

  def user
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def only_group_member(group = nil)
    group ||= Group.find(params[:id])
    group.member?(@user) or raise(Group::NotGroupMember)
  end

  def only_logged_user
    @user or raise(User::UnAuthorized)
  end
end
