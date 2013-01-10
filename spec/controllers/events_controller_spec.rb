# coding: utf-8
require 'spec_helper'

describe EventsController do
  describe "GET 'show'" do
    let(:you) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }

    before do
      @request.session[:group_id] = group.id
    end

    context 'グループがsecretではない時' do
      let(:event) { FactoryGirl.create(:event, group_id: group.id) }

      before do
        Group.any_instance.stub(:secret?) { false }
        get :show, id: event.to_param
      end

      it { response.should be_success }
      it { assigns(:comment).should be_a(Comment) }
      it { assigns(:comment).event_id.should eq event.id }
    end

    context 'グループがsecretの時' do
      let(:event) { FactoryGirl.create(:event, group_id: group.id) }

      before do
        Group.any_instance.stub(:secret?) { true }
      end

      context 'memberはアクセスできる' do
        before do
          login_as(you)
          get :show, id: event.to_param
        end

        it { response.should be_success }
      end

      context 'not memberはアクセスできない' do
        let(:other) { FactoryGirl.create(:user) }

        before do
          login_as(other)
          bypass_rescue
        end

        it { expect{ get :show, id: event.to_param }.to raise_error(Group::NotGroupMember) }
      end
    end
  end

  describe "GET 'new'" do
    let(:you) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }

    before do
      @request.session[:group_id] = group.id
    end

    context 'グループがsecretではない時' do
      before do
        Group.any_instance.stub(:secret?) { false }
        get :new
      end
      it { response.should be_success }
      it { assigns(:event).group_id.should eq group.id }
    end

    context 'グループがsecretの時' do
      before do
        Group.any_instance.stub(:secret?) { true }
      end

      context 'memberはアクセスできる' do
        before do
          login_as(you)
          get :new
        end

        it { response.should be_success }
      end

      context 'not memberはアクセスできない' do
        let(:other) { FactoryGirl.create(:user) }

        before do
          login_as(other)
          bypass_rescue
        end

        it { expect{ get :new }.to raise_error(Group::NotGroupMember) }
      end
    end
  end

  describe "GET 'edit'" do
    let(:you) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }

    before do
      @request.session[:group_id] = group.id
    end

    context 'グループがsecretではない時' do
      let(:event) { FactoryGirl.create(:event, group_id: group.id) }

      before do
        Group.any_instance.stub(:secret?) { false }
        get :edit, id: event.to_param
      end

      it { response.should be_success }
      it { assigns(:event).group_id.should eq group.id }
    end

    context 'グループがsecretの時' do
      let(:event) { FactoryGirl.create(:event, group_id: group.id) }

      before do
        Group.any_instance.stub(:secret?) { true }
      end

      context 'memberはアクセスできる' do
        before do
          login_as(you)
          get :edit, id: event.to_param
        end

        it { response.should be_success }
      end

      context 'not memberはアクセスできない' do
        let(:other) { FactoryGirl.create(:user) }

        before do
          login_as(other)
          bypass_rescue
        end

        it { expect{ get :edit, id: event.to_param }.to raise_error(Group::NotGroupMember) }
      end
    end
  end
end
