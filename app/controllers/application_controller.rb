class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :user

  rescue_from User::UnAuthorized, :with => -> { redirect_to '/users/new' }
  rescue_from Group::NotGroupMember, :with => -> { render :text => 'not group member' }
  rescue_from Group::NotGroupOwner, :with => -> { render :text => 'not group owner' }

  private

  def user
    name = session[:name]
    @user = (name && User.find_by_name(name))
  end

  def only_group_member(group = nil)
    group ||= Group.find(params[:id])
    group.member?(@user) or raise(Group::NotGroupMember)
  end

  def only_logged_user
    @user or raise(User::UnAuthorized)
  end
end
