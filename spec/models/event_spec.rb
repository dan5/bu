# coding: utf-8
require 'spec_helper'

describe Event do
  describe "Validations" do
    it { should validate_presence_of(:title) }
    it { should ensure_length_of(:title).is_at_most(32) }
  end

  describe "Associations" do
    it { should belong_to(:group) }
    it { should have_many(:comments) }
    it { should have_many(:users).through(:user_events) }
  end
end
