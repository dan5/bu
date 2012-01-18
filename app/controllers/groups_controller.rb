class GroupsController < ApplicationController
  before_filter {
    includes = %w(edit update destroy)
    if includes.include?(action_name)
      group = Group.find(params[:id])
      group.owner?(user) or raise(Group::NotGroupOwner)
    end
  }

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
      redirect_to @group, notice: 'Not joind.'
    end
  end

  def posts
    # @todo: login_required
    # @todo: 1001件目からを1として表示し古いpostsは過去ログとする
    @group = Group.find(params[:id])
    limit = 1000
    conditions = ''
    case renge = params[:renge]
    when 'all'
      limit = 1000
    when /l(\d+)/
      limit = $1.to_i
    when /(\d+)?-(\d+)?/
      s = $1 || 1
      e = $2 || @group.posts.maximum(:idx)
      conditions = ['idx >= ? and idx <= ?', s, e]
    when /(\d+)/
      limit = 1
      s = $1.to_i
      conditions = ['idx = ?', s]
    else
      limit = 10
    end
    @posts = @group.posts.where(conditions).order('idx desc').limit(limit).reverse
    @post = Post.new
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
    @events = @group.events.order('started_at desc')
  end

  # GET /groups/new
  def new
    login_required
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  def create
    login_required
    params[:group][:owner_user_id] = @user.id
    @group = Group.new(params[:group])

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
    @group.destroy

    redirect_to '/my'
  end
end
