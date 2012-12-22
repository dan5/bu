# coding: utf-8
require 'spec_helper'

describe SessionsController do

  describe '#callback' do
    let(:you) { FactoryGirl.create(:user) }
    before { User.stub(:find_or_create_with_omniauth) { you } }

    context 'redirect_pathが設定されている場合' do
      let(:redirect_path) { root_path }
      before do
        request.session[:redirect_path] = redirect_path
        get :callback, provider: :twitter
      end
      it { should redirect_to(redirect_path) }
    end

    context 'redirect_pathが設定されていない場合' do
      before { get :callback, provider: :twitter }
      it { should redirect_to(my_path) }
    end
  end

  describe '#destroy' do
    let(:you) { FactoryGirl.create(:user) }

    before do
      request.session[:user_id] = you.id
      get :destroy
    end

    it { should redirect_to(root_path) }
    it { request.session[:user_id].should be_nil }
  end

end
