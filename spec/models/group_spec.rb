# coding: utf-8
require 'spec_helper'

describe Group do
  let(:you) { FactoryGirl.create(:user) }
  subject { FactoryGirl.create(:group, owner_user_id: you.id) }

  describe 'Validations' do
    it { should validate_presence_of(:name).with_message(/can't be blank/)  }
    it { should validate_presence_of(:summary).with_message(/can't be blank/)  }
    pending { should ensure_length_of(:name).is_at_least(132).with_message(/too long/) }
    pending { should ensure_length_of(:summary).is_at_least(100).with_message(/not long enough/) }
    pending { should ensure_length_of(:description).is_at_least(4096).with_message(/not long enough/) }
  end

  describe 'Association' do
    it { should have_many(:events) }
    it { should have_many(:posts) }
    it { should have_many(:user_groups) }
    it { should have_many(:users) }
    it { should have_many(:member_requests) }
    it { should have_many(:requesting_users) }
  end

  describe "#destroy" do
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
