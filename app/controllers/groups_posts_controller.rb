class GroupsPostsController < ApplicationController
  before_filter :find_group, only: [:index, :create]
  before_filter :member_only, only: [:create]

  def index  #普通の実装になおすべき
    # @todo: 1001件目からを1として表示し古いpostsは過去ログとする
    only_group_member(@group) if @group.secret?

    limit = 1000
    conditions = ''
    case renge = params[:renge]
    when 'all'
      limit = 1000
    when /l(\d+)/
      limit = $1.to_i
    when /(\d+)?-(\d+)?/ #機能していない模様
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
    @post = @group.posts.build(params[:post]) do |model|
      model.user = @user
    end

    if @post.save
      redirect_to group_posts_url(anchor: @post.idx), notice: 'Post was successfully created.'
    else
      render action: "new"
    end
  end

  private
  def find_group
    @group = Group.find(params[:group_id])
  end

  def member_only
    only_group_member(@group)
  end
end
