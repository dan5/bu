# coding: utf-8
require 'spec_helper'

describe Group do
  describe 'Validations' do
    it { should validate_presence_of(:name)  }
    it { should validate_presence_of(:summary)  }
    it { should ensure_length_of(:name).is_at_most(32) }
    it { should ensure_length_of(:summary).is_at_most(100) }
    it { should ensure_length_of(:description).is_at_most(4096) }
  end

  describe 'Associations' do
    it { should have_many(:events) }
    it { should have_many(:posts) }
    it { should have_many(:user_groups) }
    it { should have_many(:users).through(:user_groups) }
    it { should have_many(:member_requests) }
    it { should have_many(:requesting_users).through(:member_requests) }
  end

  describe "#create" do
    let(:you) { FactoryGirl.create(:user) }
    let!(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }
    it { group.users.should include you }
  end

  describe "#update" do
    let(:you) { FactoryGirl.create(:user) }
    let(:current) { FactoryGirl.create(:group, owner_user_id: you.id, permission: permission) }
    let!(:member_request) { FactoryGirl.create(:member_request, group_id: current.id) }

    let(:edited) { FactoryGirl.attributes_for(:group) }

    context 'public group' do
      let(:permission) { 0 }
      it { expect{ current.update_attributes(edited) }.to change(MemberRequest, :count).by(-1) }
    end

    context 'not public group' do
      let(:permission) { 1 }
      it { expect{ current.update_attributes(edited) }.to change(MemberRequest, :count).by(0) }
    end
  end

  describe "#destroy" do
    let(:you) { FactoryGirl.create(:user) }

    context 'メンバーが1名以下の場合は削除できる' do
      let!(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }
      it { expect{ group.destroy }.to change(Group, :count).by(-1) }
    end

    context 'メンバーが2名以上いる場合削除できないこと' do
      let(:users) { FactoryGirl.create_list(:user, 2) }
      let!(:group) { FactoryGirl.create(:group, users: users, owner_user_id: you.id) }
      it { expect{ group.destroy }.to change(Group, :count).by(0) }
    end
  end
end
