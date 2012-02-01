class GroupsMemberRequestsController < ApplicationController
  before_filter { # for secret group
    @group = Group.find(params[:group_id])
    only_group_manager(@group)
  }

  def index
  end

  def confirm
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
    req = @group.member_requests.find(params[:id])
    req.destroy
    redirect_to :back
  rescue ActiveRecord::RecordNotFound
    redirect_to :back
  end
end
