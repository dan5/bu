class PostsController < ApplicationController
  # POST /posts
  def create
    @post = Post.new(params[:post])
    @group = @post.group
    only_group_member(@group)
    @post.user = @user
    @post.idx = @group.posts.maximum('idx').to_i + 1
    #@post.notification

    if @post.save
      path = "/groups/#{@group.id}.posts##{@post.idx}"
      redirect_to path, notice: 'Post was successfully created.'
    else
      render action: "new"
    end
  end
end
