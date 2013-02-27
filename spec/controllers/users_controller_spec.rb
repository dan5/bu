# coding: utf-8
require 'spec_helper'

describe UsersController do
  describe "GET 'show'" do
    let(:user) { FactoryGirl.create(:user) }
    before { get :show, id: user.id }
    it { assigns(:current_user).id.should eq user.id }
  end

  describe "GET 'new'" do
    before { get :new }
    it { assigns(:current_user).should be_kind_of User }
  end

  describe "GET 'edit'" do
    context 'ログインしている場合' do
      let(:you) { FactoryGirl.create(:user) }
      before do
        login_as(you)
        get :edit
      end
      it { assigns(:user).should eq you }
    end

    context 'ログインしてない場合' do
      before { bypass_rescue }
      it { expect { get :edit }.to raise_error(User::UnAuthorized) }
    end
  end

  describe "PUT 'update'" do
    context 'ログインしている場合' do
      let(:you) { FactoryGirl.create(:user) }
      before { login_as(you) }

      context 'valid params' do
        before do
          User.any_instance.should_receive(:update_attributes).with('these' => 'params').and_return { true }
          put :update, {:id => you.to_param, :user => {'these' => 'params'}}
        end

        it { response.should redirect_to('/users/edit') }
      end

      context 'invalid params' do
        before do
          User.any_instance.should_receive(:update_attributes).with('these' => 'params').and_return { false }
          put :update, {:id => you.to_param, :user => {'these' => 'params'}}
        end

        it { response.should render_template("edit") }
      end
    end

    context 'ログインしてない場合' do
      before { bypass_rescue }
      it { expect { get :edit }.to raise_error(User::UnAuthorized) }
    end
  end
end
