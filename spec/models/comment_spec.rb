# coding: utf-8
require 'spec_helper'

describe Comment do
  describe "Validations" do
    it { should validate_presence_of(:text) }
    it { should ensure_length_of(:text).is_at_most(140) }
  end

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:event) }
  end
end
