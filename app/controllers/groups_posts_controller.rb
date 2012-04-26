class GroupsPostsController < ApplicationController
  def index
    # @todo: 1001件目からを1として表示し古いpostsは過去ログとする
    @group = Group.find(params[:group_id])
    only_group_member(@group) if @group.secret?

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
    @posts = @group.posts.where(conditions).limit(limit).reverse
    @post = Post.new(:group_id => @group.id)
  end

  # POST /posts
  def create
    @post = Post.new(params[:post])
    @group = @post.group
    only_group_member(@group)
    @post.user = @user
    @post.idx = @group.posts.maximum('idx').to_i + 1
    #@post.notification

    if @post.save
      path = "/groups/#{@group.id}/posts##{@post.idx}"
      redirect_to path, notice: 'Post was successfully created.'
    else
      render action: "new"
    end
  end
end
