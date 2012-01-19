class UserGroupsController < ApplicationController
  # PUT /user_groups/1
  def update
    @user_group = UserGroup.find(params[:id])
    group = @user_group.group
    only_group_manager(group)

    @user_group.role = params[:user_group][:role]

    path = "/groups/#{group.id}.users"
    if @user_group.save
      redirect_to path, notice: 'Role was successfully updateed.'
    else
      redirect_to path
    end
  end
end
