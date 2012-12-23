# coding: utf-8
require 'spec_helper'

describe MemberRequest do
  describe "Validations" do
    before { FactoryGirl.create(:member_request) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:group_id) }
  end

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:group) }
  end
end
