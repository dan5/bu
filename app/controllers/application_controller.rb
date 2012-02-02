class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from User::NotAdministrator, :with => -> { redirect_to '/' }
  rescue_from User::UnAuthorized, :with => -> { redirect_to '/users/new' }
  rescue_from Group::NotGroupOwner, :with => -> { render :text => 'not group owner' }
  rescue_from Group::NotGroupManager, :with => -> { render :text => 'not group manager' }
  rescue_from Group::NotGroupMember, :with => -> { render :text => 'not group member' }
  rescue_from Event::NotEventManager, :with => -> { render :text => 'not event manager' }

  private

  before_filter :user
  before_filter { @subtitle = ': beta' }

  before_filter {
    if controller_name != 'users' and controller_name != 'events' and controller_name != 'sessions'
      session.delete(:redirect_path_after_event_show)
    end
  }

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

  def only_group_owner(group = nil)
    login_required
    group ||= Group.find(params[:id])
    group.owner?(@user) or raise(Group::NotGroupOwner)
  end

  def only_group_manager(group = nil)
    login_required
    group ||= Group.find(params[:id])
    group.manager?(@user) or raise(Group::NotGroupManager)
  end

  def only_group_member(group = nil)
    login_required
    group ||= Group.find(params[:id])
    group.member?(@user) or raise(Group::NotGroupMember)
  end

  def only_event_manager(event)
    login_required
    event.manager?(@user) or raise(Event::NotEventManager)
  end
end
