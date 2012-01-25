class GroupsController < ApplicationController
  def description
    session[:description] = true
    redirect_to group_path
  end

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
      if @group.requesting_user?(@user)
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

  # GET /groups
  def index
    user.administrator? or raise(User::NotAdministrator)
    @groups = Group.all
  end

  # GET /groups/1
  def show
    @group = Group.find(params[:id])
    session[:group_id] = @group.id
    @events = @group.events.limit(7)
    @show_description = session.delete(:description)
  end

  # GET /groups/new
  def new
    login_required
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
    only_group_owner(@group)
  end

  # POST /groups
  def create
    login_required
    @group = Group.new(params[:group])
    @group.owner = @user

    Group.transaction do
      if @group.save
        @group.users << @user
        redirect_to @group, notice: 'Group was successfully created.'
      else
        render action: "new"
      end
    end
  end

  # PUT /groups/1
  def update
    @group = Group.find(params[:id])
    only_group_owner(@group)
    params[:group].delete(:owner_user_id)

    if @group.update_attributes(params[:group])
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /groups/1
  def destroy
    @group = Group.find(params[:id])
    only_group_owner(@group)
    @group.destroy

    redirect_to '/my'
  end
end
