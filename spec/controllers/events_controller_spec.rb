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

    before do
      @request.session[:group_id] = group.id
      @request.session[:user_id] = you.id
    end

    context 'あなたがメンバーではない場合' do
      before do
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

  describe 'PUT update' do
    let(:you) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.create(:group, owner_user_id: you.to_param) }
    let(:event) { FactoryGirl.create(:event, group_id: group.to_param, owner_user_id: you.to_param) }

    before do
      @request.session[:user_id] = you.id
      @request.session[:group_id] = group.to_param
    end

    context 'あなたがイベント管理者ではない場合' do
      before do
        Event.any_instance.stub(:manager?) { false }
        bypass_rescue
      end

      it 'NotEventManagerになること' do
        expect { 
          put :update, event: {}, id: event.to_param
        }.to raise_error(Event::NotEventManager)
      end
    end

    context 'あなたがイベント管理者の場合' do
      before { Event.any_instance.stub(:manager?) { true } }
      
      context '有効なパラメータが送信された時' do
        before do
          Event.any_instance.stub(:update_attributes) { true }
          put :update, event: event, id: event.to_param
        end
        it { should redirect_to event_url(event.to_param) }
      end

      context '無効なパラメータが送信された時' do
        before do
          Event.any_instance.stub(:update_attributes) { false }
          put :update, event: event, id: event.to_param
        end
        it { should render_template :edit }
      end
    end
  end

  describe "DELETE destroy" do
    let(:you) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.create(:group, owner_user_id: you.to_param) }
    let!(:event) { FactoryGirl.create(:event, group_id: group.to_param, owner_user_id: you.to_param) }

    before do
      @request.session[:user_id] = you.id
      @request.session[:group_id] = group.to_param
    end

    context 'あなたがイベントマネージャーの場合' do
      before do
        Event.any_instance.stub(:manager?) { true }
      end

      it '削除できる' do 
        expect {
          delete :destroy, id: event.to_param
        }.to change(Event, :count).by(-1)
      end
    end

    context 'あなたがイベントマネージャーではない場合' do
      before do
        Event.any_instance.stub(:manager?) { false }
        bypass_rescue
      end

      it 'NotEventManagerになること' do
        expect { 
          delete :destroy, id: event.to_param
        }.to raise_error(Event::NotEventManager)
      end
    end
  end

  describe '#cancel' do
    let(:you) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }
    let(:event) { FactoryGirl.create(:event, group_id: group.id, canceled: false) }

    context 'あなたがeventマネージャーの場合' do
      before do
        login_as(you)
        get :cancel, id: event.to_param
      end
      it { assigns(:event).canceled.should be_true }
    end

    context 'eventマネージャーではない場合' do
      let(:other) { FactoryGirl.create(:user) }
      before do
        bypass_rescue
        login_as(other)
      end
      it { expect { get :cancel, id: event.to_param }.to raise_error(Event::NotEventManager) }
    end
  end

  describe '#be_active' do
    let(:you) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }
    let(:event) { FactoryGirl.create(:event, group_id: group.id, canceled: true) }

    context 'あなたがeventマネージャーの場合' do
      before do
        login_as(you)
        get :be_active, id: event.to_param
      end
      it { assigns(:event).canceled.should be_false }
    end

    context 'eventマネージャーではない場合' do
      let(:other) { FactoryGirl.create(:user) }
      before do
        bypass_rescue
        login_as(other)
      end
      it { expect { get :be_active, id: event.to_param }.to raise_error(Event::NotEventManager) }
    end
  end
end
