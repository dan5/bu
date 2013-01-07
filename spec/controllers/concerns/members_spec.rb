# coding: utf-8
require 'spec_helper'

describe Members do
  include RSpec::Rails::ControllerExampleGroup

  controller do
    include Members
  end

  describe '#join' do
    before do
      @routes.draw { get "anonymous/:id/join" => "anonymous#join" }
    end

    let(:you) { FactoryGirl.create(:user) }

    context 'ログインしていない場合' do
      let!(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }

      before { bypass_rescue }
      it { expect { get :join, id: group.to_param }.to raise_error(User::UnAuthorized) }
    end

    context 'ログインしている場合' do
      let!(:group) { FactoryGirl.create(:group, owner_user_id: you.id, permission: permission) }

      context 'グループがpublicである場合' do
        let(:permission) { 0 }

        context 'ユーザーがメンバーの場合' do
          before { login_as(you) }
          it { expect { get :join, id: group.to_param }.to change(UserGroup, :count).by(0) }
        end

        context 'ユーザーがメンバーではない場合' do
          let(:other) { FactoryGirl.create(:user) }
          before { login_as(other) }
          it { expect { get :join, id: group.to_param }.to change(UserGroup, :count).by(+1) }
        end
      end

      context 'グループがpublicでない場合' do
        let(:permission) { 1 }
        it { expect { get :join, id: group.to_param }.to change(UserGroup, :count).by(0) }
      end
    end
  end

  describe '#leave' do
    let(:you) { FactoryGirl.create(:user) }
    let!(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }

    before do
      @routes.draw { get "anonymous/:id/leave" => "anonymous#leave" }
    end

    context 'ユーザーがメンバーの場合' do
      before { login_as(you) }
      it { expect { get :leave, id: group.to_param }.to change(UserGroup, :count).by(-1) }
    end

    context 'ユーザーがメンバーではない場合' do
      let(:other) { FactoryGirl.create(:user) }
      before { login_as(other) }
      it { expect { get :leave, id: group.to_param }.to change(UserGroup, :count).by(0) }
    end
  end

  describe '#request_to_join' do
    let(:you) { FactoryGirl.create(:user) }

    before do
      @routes.draw { get "anonymous/:id/request_to_join" => "anonymous#request_to_join" }
    end

    context 'ログインしていない場合' do
      let!(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }

      before { bypass_rescue }
      it { expect { get :request_to_join, id: group.to_param }.to raise_error(User::UnAuthorized) }
    end

    context 'ログインしている場合' do
      let!(:group) { FactoryGirl.create(:group, owner_user_id: you.id, permission: permission) }

      context 'グループがpublicである場合' do
        let(:permission) { 0 }
        it { expect { get :request_to_join, id: group.to_param }.to change(MemberRequest, :count).by(0) }
      end

      context 'グループがpublicでない場合' do
        let(:permission) { 1 }

        context 'ユーザーがメンバーの場合' do
          before { login_as(you) }
          it { expect { get :request_to_join, id: group.to_param }.to change(MemberRequest, :count).by(0) }
        end

        context 'ユーザーがメンバーリクエスト済の場合' do
          let(:other) { FactoryGirl.create(:user) }
          before do
            login_as(other)
            group.requesting_users << other
          end
          it { expect { get :request_to_join, id: group.to_param }.to change(MemberRequest, :count).by(0) }
        end

        context 'ユーザーがメンバーではない場合' do
          let(:other) { FactoryGirl.create(:user) }
          before { login_as(other) }
          it { expect { get :request_to_join, id: group.to_param }.to change(MemberRequest, :count).by(+1) }
        end
      end
    end
  end
end
