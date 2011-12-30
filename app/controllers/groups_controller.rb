class GroupsController < ApplicationController
  # GET /groups
  def index
    @groups = Group.all
  end

  # GET /groups/1
  def show
    @group = Group.find(params[:id])
    session[:group_id] = @group.id
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
    owner_only!
  end

  # POST /groups
  def create
    params[:group][:owner_user_id] = user.id
    @group = Group.new(params[:group])

    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /groups/1
  def update
    @group = Group.find(params[:id])
    owner_only!
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
    owner_only!
    @group.destroy

    redirect_to groups_url
  end

  private

  def owner_only!
    user.id == @group.owner.id or raise "You are not owner!"
  end
end
