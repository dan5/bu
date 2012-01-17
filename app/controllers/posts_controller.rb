class PostsController < ApplicationController
  # GET /posts
  def index
    @posts = Post.all
    # @todo: delete this action
  end

  # GET /posts/1
  def show
    @post = Post.find(params[:id])
    # @todo: only_group_member(@post.group)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # POST /posts
  def create
    group = Group.find(session[:group_id])
    only_group_member(group)
    @post = group.posts.new(params[:post])
    @post.user = @user

    if @post.save
      redirect_to group, notice: 'Post was successfully created.'
    else
      render action: "new"
    end
  end
end
