class EventsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, :with => -> { redirect_to :back, :notice => 'error' }

  before_filter { # for secret group
    params[:id] or return
    group = Event.find(params[:id]).group
    only_group_member(group) if group.secret?
  }

  after_filter {
    if action_name == 'show'
      session[:redirect_path_after_event_show] = "/events/#{@event.id}"
    end
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
    notice = nil
    Event.transaction do
      if group.public? and !group.member?(@user)
        group.users << @user
      end
      only_group_member(event.group)
      if @user.atnd(event)
        notice = 'atnd already is exist.'
      else
        @user.attend(event)
      end
    end
    redirect_to session[:redirect_path_after_event_show] || :back, notice: notice
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
    set_subtitle
  end

  # GET /events/new
  def new
    @event = Event.new
    # todo: use hidden
    @group = Group.find(session[:group_id])
    @event.group = @group
    set_subtitle 'new'
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @group = @event.group
    set_subtitle
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

  private

  def set_subtitle(title = nil)
    @subtitle = ": #{@event.group.name} #{title or @event.title}"
  end
end
