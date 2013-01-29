# coding: utf-8
require 'spec_helper'

describe GroupsUsersController do
  let(:you) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }
  let!(:events) { FactoryGirl.create_list(:event, 10, group_id: group.id) }

  context 'GET index' do
    before { get :index, group_id: group.to_param }

    it { assigns(:events).first.group_id.should eq group.id }
    it { assigns(:events).count.should eq events.count }
    it { assigns(:group).should eq group }
  end

  context 'GET show' do
    before { get :show, id: you.to_param, group_id: group.to_param }

    it { assigns(:events).count.should eq events.count }
    it { assigns(:group).should eq group }
    it { assigns(:current_user).should eq you }
  end
end
