# coding: utf-8
require 'spec_helper'

describe User do
  describe "Validations" do
    # validate_uniqueness_of matcher は既存のレコードが必要
    before { FactoryGirl.create(:user) }
    it { should validate_presence_of(:name).with_message(/can't be blank/) }
    it { should ensure_length_of(:name).is_at_most(16).with_long_message(/too long/) }
    it { should validate_uniqueness_of(:uid).scoped_to(:provider).with_message(/already been taken/) }
  end

  describe "Associations" do
    it { should have_many(:comments) }
    it { should have_many(:groups).through(:user_groups) }
    it { should have_many(:events).through(:user_events) }
    it { should have_many(:requested_groups).through(:member_requests) }
  end

  describe '.find_or_create_with_omniauth' do
    subject { User.find_or_create_with_omniauth(auth) }

    context 'not exists' do
      let(:you) { FactoryGirl.attributes_for(:user) }
      let(:auth) do
        {
          'provider' => you[:provider],
          'uid' => you[:uid],
          'info' => {'nickname' => you[:name], 'image' => you[:image]}
        }
      end

      it { subject.uid.should eq you[:uid] }
      it { subject.provider.should eq you[:provider] }
    end

    context 'exists' do
      let(:you) { FactoryGirl.create(:user) }
      let(:auth) do
        {
          'provider' => you.provider,
          'uid' => you.uid,
          'info' => {'nickname' => you.name, 'image' => you.image}
        }
      end

      it { should eq you }
    end
  end
end
