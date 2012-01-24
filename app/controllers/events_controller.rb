class EventsController < ApplicationController
  def delete
    event = Event.find(params[:id])
    @user.atnd(event).destroy
    redirect_to :back
  end

  def attend
    event = Event.find(params[:id])
    only_group_member(group)
    atnd = @user.attend(event)
    redirect_to :back
  end

  def absent
    event = Event.find(params[:id])
    only_group_member(group)
    atnd = @user.be_absent(event)
    redirect_to :back
  end

  def maybe
    event = Event.find(params[:id])
    only_group_member(group)
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

    redirect_to events_url
  end
end
