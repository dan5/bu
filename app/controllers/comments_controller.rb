class CommentsController < ApplicationController
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  def create
    login_required
    @comment = @user.comments.new(params[:comment])
    only_group_member(@comment.event.group)

    if @comment.save
      redirect_to @comment.event, notice: 'Comment was successfully created.'
    else
      render action: "new"
    end
  end

  # DELETE /comments/1
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    redirect_to comments_url
  end
end
