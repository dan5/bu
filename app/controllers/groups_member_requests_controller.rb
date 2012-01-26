class GroupsMemberRequestsController < ApplicationController
  def index
    @group = Group.find(params[:group_id])
    @events = @group.events
  end

  def confirm
    @group = Group.find(params[:group_id])
    only_group_manager(@group)
    req = @group.member_requests.find(params[:id])
    Group.transaction do
      req.destroy
      @group.users << req.user
    end
    redirect_to :back
  rescue ActiveRecord::RecordNotFound
    redirect_to :back
  end

  def reject
    @group = Group.find(params[:group_id])
    only_group_manager(@group)
    req = @group.member_requests.find(params[:id])
    req.destroy
    redirect_to :back
  rescue ActiveRecord::RecordNotFound
    redirect_to :back
  end
end
