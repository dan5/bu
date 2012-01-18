class PostsController < ApplicationController
  # POST /posts
  def create
    @group = Group.find(session[:group_id])
    only_group_member(@group)
    @post = @group.posts.new(params[:post])
    @post.user = @user
    @post.idx = @group.posts.maximum('idx').to_i + 1

    if @post.save
      path = "/groups/#{@group.id}.posts##{@post.idx}"
      redirect_to path, notice: 'Post was successfully created.'
    else
      render action: "new"
    end
  end
end
