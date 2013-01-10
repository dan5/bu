# coding: utf-8
require 'spec_helper'

describe EventsController do
  describe "GET 'show'" do
    let(:group) { FactoryGirl.create(:group) }
    let(:event) { FactoryGirl.create(:event, group_id: group.id) }

    before { get :show, id: event.to_param }

    it { response.should be_success }
    it { assigns(:comment).should be_a(Comment) }
    it { assigns(:comment).event_id.should eq event.id }
  end

  describe "GET 'new'" do
    let(:group) { FactoryGirl.create(:group) }

    before do
      @request.session[:group_id] = group.id
      get :new
    end

    it { response.should be_success }
  end
end
