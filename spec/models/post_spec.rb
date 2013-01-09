# coding: utf-8
require 'spec_helper'

describe Post do
  describe "Validations" do
    before do
      Post.any_instance.stub(:next_idx) { 1 }
      FactoryGirl.create(:post)
    end

    it { should validate_uniqueness_of(:idx).scoped_to(:group_id) }
    it { should ensure_length_of(:subject).is_at_most(40) }
    it { should validate_presence_of(:text) }
    it { should ensure_length_of(:text).is_at_most(1000) }
  end

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:group) }
  end

  describe '#idx' do
    let(:group) { FactoryGirl.create(:group) }
    let(:other_group) { FactoryGirl.create(:group) }

    let!(:posts) { FactoryGirl.create_list(:post, Forgery::Basic.number, group: group) }
    let!(:other_posts) { FactoryGirl.create_list(:post, Forgery::Basic.number, group: other_group) }

    subject { FactoryGirl.create(:post, group: group) }
    it { subject.idx.should eq posts.count + 1 }
  end
end
