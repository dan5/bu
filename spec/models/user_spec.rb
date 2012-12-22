# coding: utf-8
require 'spec_helper'

describe User do
  describe '.find_or_create_with_ominiauth' do
    context 'not exists' do
      let(:you) { FactoryGirl.attributes_for(:user) }
      let(:auth) do
        {
          'provider' => you[:provider],
          'uid' => you[:uid],
          'info' => {'nickname' => you[:name], 'image' => you[:image]}
        }
      end

      subject { User.find_or_create_with_ominiauth(auth) }

      it { subject.uid.should eq you[:uid] }
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

      subject { User.find_or_create_with_ominiauth(auth) }

      it { should eq you }
    end
  end
end
