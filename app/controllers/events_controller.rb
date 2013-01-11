class EventsController < ApplicationController
  include ::Attendees
  rescue_from ActiveRecord::RecordInvalid, :with => -> { redirect_to :back, :notice => 'error' }

  before_filter :find_group, only: [:new, :edit, :show, :create]
  before_filter :member_only, only: [:new, :edit, :show]
  before_filter :member_only_for_create, only: [:create]
  before_filter :find_event, only: [:show]

  after_filter(only: :show) {
    session[:redirect_path_after_event_show] = event_url(@event.id)
  }

  # GET /events/1
  def show
    @comment = @event.comments.build
    set_subtitle
  end

  # GET /events/new
  def new
    @event = @group.events.build
    set_subtitle 'new'
  end

  # GET /events/1/edit
  def edit
    @event = @group.events.find(params[:id])
    set_subtitle
  end

  # POST /events
  def create
    @event = @group.events.new(params[:event]) do |model|
      model.owner = current_user
    end

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
    @event = @group.events.find(params[:id])
  end

  def find_group
    @group = Group.find(session[:group_id])
  end

  def member_only #TODO
    only_group_member(@group) if @group.secret?
  end

  def member_only_for_create #TODO
    only_group_member(@group)
  end

  def current_user
    @user
  end
end
