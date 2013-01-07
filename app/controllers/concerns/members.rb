# coding: utf-8
# TODO: 適正なcontrollerに再配置する
module Members
  def leave
    @group = Group.find(params[:id])
    only_group_member(@group)
    @group.users.delete(@user)
    redirect_to @group, notice: 'Left.'
  end

  def join
    login_required
    @group = Group.find(params[:id])
    if @group.public?
      if @group.member?(@user)
        redirect_to @group, notice: 'You already are a member of this group.'
      else
        @group.users << @user
        redirect_to @group, notice: 'Joined.'
      end
    else
      redirect_to @group, notice: 'Not joined.'
    end
  end

  def request_to_join
    login_required
    @group = Group.find(params[:id])
    unless @group.public?
      if @group.member?(@user)
        redirect_to @group, notice: 'You already are a member of this group.'
      elsif @group.requesting_user?(@user)
        redirect_to @group, notice: 'You already requested to join this group.'
      else
        @group.requesting_users << @user
        redirect_to @group, notice: 'Requested.'
      end
    else
      redirect_to @group, notice: 'Not requested.'
    end
  end

  def delete_request
    login_required
    @group = Group.find(params[:id])
    if @group.requesting_user?(@user)
      @group.requesting_users.delete @user
      redirect_to @group, notice: 'Deleted request.'
    else
      redirect_to @group, notice: 'Not deleted request.'
    end
  end
end
