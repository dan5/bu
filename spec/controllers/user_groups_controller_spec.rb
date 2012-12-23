# coding: utf-8
require 'spec_helper'

describe UserGroupsController do
  let!(:you) { FactoryGirl.create(:user) }
  let!(:member) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group, owner_user_id: owner.id) }
  let!(:user_group) { FactoryGirl.create(:user_group, group_id: group.id, user_id: member.id) }
  let(:edited_user_group) { FactoryGirl.attributes_for(:user_group, group_id: group.id, user_id: member.id) }

  before { request.session[:user_id] = you.id }

  describe "PUT update" do #groupにおける役職名の設定
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
    context 'Ownerの場合は削除できること' do
      let(:owner) { you }
      it { expect { delete :destroy, {id: user_group.to_param} }.to change(UserGroup, :count).by(-1) }
    end

    context 'Ownerじゃない場合は削除できないこと' do
      let(:owner) { FactoryGirl.create(:user) }
      before { bypass_rescue }
      it { expect { delete :destroy, {id: user_group.to_param} }.to raise_error(Group::NotGroupManager) }
    end

    context 'Owner自身は削除できること' do
      let(:owner) { you }
      let(:user_group_id) { UserGroup.where(user_id: you.id, group_id: group.id).first }
      it { expect { delete :destroy, {id: user_group_id} }.to change(UserGroup, :count).by(0) }
    end
  end
end
