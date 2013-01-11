# coding: utf-8
require 'spec_helper'

describe EventsController do
  describe "GET 'show'" do
    let(:event) { FactoryGirl.create(:event, group_id: group.id) }

    context 'グループがsecretではない時' do
      include_examples 'member of group' do
        let(:action) { get :show, id: event.to_param }
      end
      it { assigns(:comment).event_id.should eq event.id }
    end

    context 'グループがsecretの時' do
      include_examples 'member of secret group' do
        let(:action) { get :show, id: event.to_param }
      end
    end
  end

  describe "GET 'new'" do
    context 'グループがsecretではない時' do
      include_examples 'member of group' do
        let(:action) { get :new }
      end
      it { assigns(:event).group_id.should eq group.id }
    end

    context 'グループがsecretの時' do
      include_examples 'member of secret group' do
        let(:action) { get :new }
      end
    end
  end

  describe "GET 'edit'" do
    let(:event) { FactoryGirl.create(:event, group_id: group.id) }

    context 'グループがsecretではない時' do
      include_examples 'member of group' do
        let(:action) { get :edit, id: event.to_param }
      end
      it { assigns(:event).group_id.should eq group.id }
    end

    context 'グループがsecretの時' do
      include_examples 'member of secret group' do
        let(:action) { get :edit, id: event.to_param }
      end
    end
  end
  
  describe "POST 'create'" do
    let(:you) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }
    let(:event) { FactoryGirl.attributes_for(:event) }

    before { @request.session[:group_id] = group.id }

    context 'あなたがメンバーではない場合' do
      before do
        @request.session[:user_id] = you.id
        EventsController.any_instance.stub(:current_user) { you }
        Group.any_instance.stub(:member?) { false }
        bypass_rescue
      end

      it 'NotGroupMemberになること' do
        expect { 
          post :create, {event: event}
        }.to raise_error(Group::NotGroupMember)
      end
    end

    context 'あなたがメンバーの場合' do
      before do
        @request.session[:user_id] = you.id
        EventsController.any_instance.stub(:current_user) { you }
        Group.any_instance.stub(:member?) { true }
      end

      context '有効なパラメータが送信された時' do
        before do
          Event.any_instance.stub(:save) { true }
          post :create, {event: event}
        end
        it { should redirect_to events_url }
      end
      context '無効なパラメータが送信された時' do
        before do
          Event.any_instance.stub(:save) { false }
          post :create, {event: event}
        end
        it { should render_template :new }
      end
    end
  end
end
