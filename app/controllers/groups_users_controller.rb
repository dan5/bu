class GroupsUsersController < ApplicationController
  before_filter :find_group, :group_member_only

  def index
    @events = @group.events
  end

  def show
    @current_user = @group.users.find(params[:id])
    @user_group = @current_user.user_group(@group)

    time = @user_group.created_at
    if oldst = @current_user.user_events.minimum(:created_at)
      time = oldst if oldst < time
    end
    @events = @group.events.where('created_at >= ?', time)
  end

  private
  def find_group
    @group = Group.find(params[:group_id])
  end

  def group_member_only
    only_group_member(@group) if @group.secret?
  end
end
