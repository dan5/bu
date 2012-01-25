class GroupsMemberRequestsController < ApplicationController
  def index
    @group = Group.find(params[:group_id])
    @events = @group.events
  end
end
