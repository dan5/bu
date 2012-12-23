# coding: utf-8
require 'spec_helper'

describe UserEvent do
  describe "Validations" do
    before { FactoryGirl.create(:user_event) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:event_id) }
  end

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:event) }
  end
end
