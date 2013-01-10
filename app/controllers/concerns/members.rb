# coding: utf-8
# TODO: 適正なcontrollerに再配置する
module Members
  extend ActiveSupport::Concern

  included do
    before_filter :_find_group, only: [:join, :leave, :request_to_join, :delete_request] #TODO インクルード先での衝突回避
    before_filter :login_user_only, only: [:join, :request_to_join, :delete_request] #よくわからん
    before_filter :member_only, only: [:leave]
  end

  def leave
    @group.users.delete(@user)
    redirect_to @group, notice: 'Left.'
  end

  def join
    unless @group.public?
      redirect_to @group, notice: 'Not joined.'
      return
    end

    if @group.member?(@user)
      redirect_to @group, notice: 'You already are a member of this group.'
    else
      @group.users << @user
      redirect_to @group, notice: 'Joined.'
    end
  end

  def request_to_join
    if @group.public?
      redirect_to @group, notice: 'Not requested.'
      return
    end

    if @group.member?(@user)
      redirect_to @group, notice: 'You already are a member of this group.'
    elsif @group.requesting_user?(@user)
      redirect_to @group, notice: 'You already requested to join this group.'
    else
      @group.requesting_users << @user
      redirect_to @group, notice: 'Requested.'
    end
  end

  def delete_request
    if @group.requesting_user?(@user)
      @group.requesting_users.delete @user
      redirect_to @group, notice: 'Deleted request.'
    else
      redirect_to @group, notice: 'Not deleted request.'
    end
  end

  private
  def _find_group #TODO インクルード先での衝突回避
    @group = Group.find(params[:id])
  end

  def member_only #TODO
    only_group_member(@group)
  end

  def login_user_only
    login_required
  end
end
