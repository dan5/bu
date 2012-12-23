# coding: utf-8
class UserGroupsController < ApplicationController
  before_filter :find_user_group, :find_group, :manager_only

  def update
    if @user_group.update_attributes(user_group_params)
      redirect_to group_users_url(@group.id), notice: 'Role was successfully updateed.'
    else
      redirect_to group_users_url(@group.id)
    end
  end

  def destroy
    if @group.owner?(@user_group.user) #対象がオーナーの場合は削除できない
      redirect_to group_users_url(@group.id), notice: 'Cannot remove owner.'
      return
    end

    @user_group.destroy
    redirect_to group_users_url(@group.id), notice: 'Remeved member.'
  end

  private
  def find_user_group
    @user_group = UserGroup.find(params[:id])
  end

  def find_group
    @group = @user_group.group
  end

  def manager_only
    only_group_manager(@group)
  end

  def user_group_params
    { role: params[:user_group].try(:[], :role) }
  end
end
