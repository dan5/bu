# coding: utf-8
require 'spec_helper'

describe Attendees do
  include RSpec::Rails::ControllerExampleGroup

  controller do
    include Attendees
  end

  let(:you) { FactoryGirl.create(:user) }

  describe '#attend' do
    before do
      @routes.draw { get "anonymous/:id/join" => "anonymous#attend" }
    end

    context 'ログインしている場合' do
      before do
        # redirect先の設定。 :backで指定しているため
        # HTTP_REFERERがないと落ちる
        @request.env['HTTP_REFERER'] = 'http://test.host/'
      end

      let(:group) { FactoryGirl.create(:group, owner_user_id: you.id, permission: permission) }
      let!(:event) { FactoryGirl.create(:event, group_id: group.id) }

      context 'グループがpublicの場合' do
        let(:permission) { 0 }

        context 'あなたがグループメンバーの場合' do
          before { login_as(you) }
          it { expect { get :attend, id: event.to_param }.to change(UserEvent, :count).by(+1) }
        end

        context 'あなたがグループメンバーではない場合' do
          let(:other) { FactoryGirl.create(:user) }
          before { login_as(other) }
          it { expect { get :attend, id: event.to_param }.to change(UserEvent, :count).by(+1) }
        end

        context 'あなたがattend済の場合' do
          before do
            User.any_instance.stub(:atnd) { true }
            login_as(you)
          end
          it { expect { get :attend, id: event.to_param }.to change(UserEvent, :count).by(0) }
        end

        context 'あなたがattend済ではない場合' do
          before do
            User.any_instance.stub(:atnd) { false }
            login_as(you)
          end
          it { expect { get :attend, id: event.to_param }.to change(UserEvent, :count).by(+1) }
        end
      end

      context 'グループがpublicではない場合' do
        let(:permission) { 1 }

        context 'あなたがグループメンバーの場合' do
          before { login_as(you) }
          it { expect { get :attend, id: event.to_param }.to change(UserEvent, :count).by(+1) }
        end

        context 'あなたがグループメンバーではない場合' do
          let(:other) { FactoryGirl.create(:user) }
          before { login_as(other) }
          it { expect { get :attend, id: event.to_param }.to change(UserEvent, :count).by(0) }
        end
      end
    end

    context 'ログインしていない場合' do
      let(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }
      let!(:event) { FactoryGirl.create(:event, group_id: group.id) }
      before { bypass_rescue }
      it { expect { get :attend, id: event.to_param }.to raise_error(User::UnAuthorized) }
    end
  end
end
