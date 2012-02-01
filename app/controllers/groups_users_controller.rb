class GroupsUsersController < ApplicationController
  before_filter { # for secret group
    @group = Group.find(params[:group_id])
    only_group_member(@group) if @group.secret?
  }

  def index
    @group ||= Group.find(params[:group_id])
    @events = @group.events
  end

  def show
    @group ||= Group.find(params[:group_id])
    @current_user = @group.users.find(params[:id])
    @user_group = @current_user.user_group(@group)

    time = @user_group.created_at
    if oldst = @current_user.user_events.minimum(:created_at)
      time = oldst if oldst < time
    end
    @events = @group.events.where('created_at >= ?', time)
  end
end
