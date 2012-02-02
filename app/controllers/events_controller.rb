class EventsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, :with => -> { redirect_to :back, :notice => 'error' }

  before_filter { # for secret group
    params[:id] or return
    group = Event.find(params[:id]).group
    only_group_member(group) if group.secret?
  }

  def delete
    event = Event.find(params[:id])
    if atnd = @user.atnd(event)
      atnd.destroy
      redirect_to :back
    else
      redirect_to :back, :notice => 'error: Not deleted.'
    end
  end

  def attend
    login_required
    event = Event.find(params[:id])
    group = event.group
    goto = :back # todo var name
    Event.transaction do
      if group.public? and !group.member?(@user)
        group.users << @user
        goto = event # todo: このやり方では下記問題がある
      end
      only_group_member(event.group)
      atnd = @user.attend(event)
    end
    # todo: eventページから未ログインかつグループメンバー状態で来たときにeventページに戻らないので
    #       :back 指定で戻る場所をログインアクションのときに改ざんしたい
    redirect_to goto
  end

  def absent
    event = Event.find(params[:id])
    only_group_member(event.group)
    atnd = @user.be_absent(event)
    redirect_to :back
  end

  def maybe
    event = Event.find(params[:id])
    only_group_member(event.group)
    atnd = @user.be_maybe(event)
    redirect_to :back
  end

  # GET /events/1
  def show
    @event = Event.find(params[:id])
    @comment = Comment.new(:event_id => @event.id)
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  def create
    # todo: use hidden
    params[:event].delete(:group_id)
    group = Group.find(session[:group_id])
    only_group_member(group)
    @event = group.events.new(params[:event])
    @event.owner = @user

    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /events/1
  def update
    @event = Event.find(params[:id])
    only_event_manager(@event)

    if @event.update_attributes(params[:event])
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /events/1
  def destroy
    @event = Event.find(params[:id])
    only_event_manager(@event)
    @event.destroy

    redirect_to @event.group
  end
end
