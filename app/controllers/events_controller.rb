class EventsController < ApplicationController
  include Attendees
  rescue_from ActiveRecord::RecordInvalid, :with => -> { redirect_to :back, :notice => 'error' }

  before_filter { # for secret group
    params[:id] or return
    group = Event.find(params[:id]).group
    only_group_member(group) if group.secret?
  }

  before_filter :find_event, only: [:show]

  after_filter {
    if action_name == 'show'
      session[:redirect_path_after_event_show] = "/events/#{@event.id}"
    end
  }

  # GET /events/1
  def show
    @comment = @event.comments.build
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

  def cancel
    @event = Event.find(params[:id])
    only_event_manager(@event)
    @event.cancel
    redirect_to @event, notice: 'Event was successfully canceled.'
  end

  def be_active
    @event = Event.find(params[:id])
    only_event_manager(@event)
    @event.be_active
    redirect_to @event, notice: 'Event is active.'
  end

  private

  def set_subtitle(title = nil)
    @subtitle = ": #{@event.group.name} #{title or @event.title}"
  end

  def find_event
    @event = Event.find(params[:id])
  end
end
