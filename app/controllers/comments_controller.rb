# coding: utf-8
class CommentsController < ApplicationController
  before_filter :find_comment, only: [:show, :destroy]
  before_filter :login_required, :group_member_only, only: :create

  def show
  end

  # POST /comments
  def create
    @comment = @user.comments.new(params[:comment])
    if @comment.save
      redirect_to @comment.event, notice: 'Comment was successfully created.'
    else
      render :new
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    redirect_to comments_url
  end

  private
  def find_comment
    @comment = Comment.find(params[:id])
  end

  def group_member_only
    event = Event.find(params[:comment][:event_id]) #TODO ネステッドリソースにする
    only_group_member(event.group)
  end
end
