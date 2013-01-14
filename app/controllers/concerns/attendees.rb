# coding: utf-8
# TODO: 適正なcontrollerに再配置する
module Attendees

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
end
