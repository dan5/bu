# coding: utf-8
require 'spec_helper'

describe UserGroupsController do
  describe "PUT update" do #groupにおける役職名の設定
    let!(:you) { FactoryGirl.create(:user) }
    let!(:member) { FactoryGirl.create(:user) }
    let!(:group) { FactoryGirl.create(:group, owner_user_id: owner.id) }
    let!(:user_group) { FactoryGirl.create(:user_group, group_id: group.id, user_id: member.id) }
    let(:edited_user_group) { FactoryGirl.attributes_for(:user_group, group_id: group.id, user_id: member.id) }

    before { request.session[:user_id] = you.id }

    context "with valid params" do
      context "Managerの場合は更新できること" do
        let(:owner) { you }
        before { put :update, { id: user_group.to_param, user_group:  edited_user_group } }
        it { response.should redirect_to(group_users_url(group_id: group.id)) }
      end

      context "Managerでない場合は更新できないこと" do
        let(:owner) { FactoryGirl.create(:user) }
        before { bypass_rescue }
        it { expect { put :update, {id: user_group.to_param, user_group: edited_user_group } }.to raise_error(Group::NotGroupManager) }
      end

      context 'update_attributesが呼ばれていること' do
        let(:owner) { you }
        before { UserGroup.any_instance.should_receive(:update_attributes).with(role: 'a') }
        it { put :update, {id: user_group.to_param, user_group: {role: 'a'}} }
      end
    end

    context "with invalid params" do
      let(:owner) { you }
      before { put :update, {id: user_group.to_param, user_group: {}} }
      it { response.should redirect_to(group_users_url(group_id: group.id)) }
    end
  end

  describe "DELETE destroy" do
    let(:owner) { FactoryGirl.create(:user) }
    let(:target) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.create(:group, owner_user_id: owner.id) }
    let(:target_user_groups_id) { target.user_groups.where(:group_id => group.id).first.to_param }

    before do
      request.session[:user_id] = operator.id
    end

    context '操作者がOwnerのとき' do
      let(:operator) { owner }
      before do
        group.users << target
      end
      it '対象者が削除されること' do
        expect {
          delete :destroy, {id: target_user_groups_id}
        }.to change(UserGroup, :count).by(-1)
      end
    end

    context '操作者がManagerのとき' do
      let(:operator) { FactoryGirl.create(:user) }
      before do
        # managerにする
        FactoryGirl.create(:user_group, user_id: operator.id, group_id: group.id, role: 'role')
      end
      context '対象者がOwnerのとき' do
        let(:target) { owner }
        it '対象者が削除されないこと' do
          expect {
            delete :destroy, {id: target_user_groups_id}
          }.not_to change(UserGroup, :count)
        end
      end
      context '対象者がOwnerではないとき' do
        before do
          group.users << target
        end
        it '対象者が削除されること' do
          expect {
            delete :destroy, {id: target_user_groups_id}
          }.to change(UserGroup, :count).by(-1)
        end
      end
    end

    context '操作者がOwnerでもManagerでもないとき' do
      let(:operator) { FactoryGirl.create(:user) }
      before do
        bypass_rescue
        group.users << operator
        group.users << target
      end
      it 'Group::NotGroupManagerが発生すること' do
        expect {
          delete :destroy, {id: target_user_groups_id}
        }.to raise_error(Group::NotGroupManager)
      end
    end
  end
end
