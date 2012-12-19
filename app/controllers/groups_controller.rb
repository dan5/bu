# coding: utf-8
class GroupsController < ApplicationController
  before_filter :admin_only, only: :index
  before_filter :find_group, only: [:show, :edit, :update, :destroy]
  before_filter :login_required, only: [:new, :create] #TODO:権限周りはまとめて整理する
  before_filter :owner_only, only: [:edit, :update, :destroy] #TODO:権限周りはまとめて整理する

  def index
    @groups = Group.all
  end

  def show
    @events = @group.events.limit(7)
    session[:group_id] = @group.id #TODO: ネステッドリソースにする
    @show_description = session.delete(:description) #TODO: javascriptにする。そもそもいるの？
    set_subtitle #TODO: https://github.com/lwe/page_title_helper
  end

  def new
    @group = Group.new
    set_subtitle 'new group' #TODO: https://github.com/lwe/page_title_helper
  end

  def edit
    set_subtitle #TODO: https://github.com/lwe/page_title_helper
  end

  def create
    @group = Group.new(params[:group])
    @group.owner = @user #TODO: super classのインスタンンス変数を参照しない
    @group.users << @user # to model

    if @group.save
      redirect_to group_url(@group), notice: 'Group was successfully created.'
    else
      render action: "new"
      set_subtitle 'new group' #TODO: https://github.com/lwe/page_title_helper
    end
  end

  def update
    params[:group].delete(:owner_user_id) #to model

    Group.transaction do #remove
      if @group.update_attributes(params[:group])
        @group.member_requests.delete_all if @group.public? # to model
        redirect_to @group, notice: 'Group was successfully updated.'
      else
        render action: "edit"
        set_subtitle #TODO: https://github.com/lwe/page_title_helper
      end
    end
  end

  # DELETE /groups/1
  def destroy
    if @group.users.count <= 1 #TODO: 必要?
      @group.destroy
      redirect_to my_url, notice: 'Group was successfully deleted.'
    else
      redirect_to :back, notice: 'Remove all users.'
    end
  end

  private

  def set_subtitle(title = nil) #TODO: https://github.com/lwe/page_title_helper
    @subtitle = ": #{title or @group.name}"
  end

  def find_group
    @group = Group.find(params[:id])
  end

  def admin_only #TODO
    user.administrator? or raise(User::NotAdministrator)
  end

  def owner_only #TODO
    only_group_owner(@group)
  end
end
