# coding: utf-8
require 'spec_helper'

describe UserGroup do
  describe "Validations" do
    before { FactoryGirl.create(:user_group) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:group_id) }
    it { should ensure_length_of(:role).is_at_most(16) }
  end

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:group) }
  end
end
