# coding: utf-8
require 'spec_helper'

describe GroupsController do
  describe "GET 'index'" do

    context 'Administrator' do
      before do
        GroupsController.any_instance.stub_chain(:user, :administrator?) { true }
        get :index
      end

      it { response.should be_success }
    end

    context 'Not Administrator' do
      before do
        bypass_rescue
        GroupsController.any_instance.stub_chain(:user, :administrator?) { false }
      end
      it { expect { get :index }.to raise_error(User::NotAdministrator) }
    end
  end

  describe "GET 'show'" do
    let!(:group) { FactoryGirl.create(:group) }
    let!(:event) { FactoryGirl.create(:event, group_id: group.id) }

    before { get :show, id: group.to_param }
    it { response.should be_success }
  end

  describe "GET 'new'" do
    context 'LoginUserはアクセスできること' do
      before do
        GroupsController.any_instance.stub(:login_required) { true }
        get :new
      end

      it { response.should be_success }
    end

    context 'Not LoginUserはアクセスできないこと' do
      before { bypass_rescue }
      it { expect { get :new }.to raise_error(User::UnAuthorized) }
    end
  end

  describe "GET 'edit'" do
    let(:you) { FactoryGirl.create(:user) }
    let!(:group) { FactoryGirl.create(:group, owner_user_id: owner.id) }
    before { login_as(you) }

    context 'Ownerの場合はアクセスできること' do
      let(:owner) { you }
      before { get :edit, id: group.to_param }
      it { response.should be_success }
    end

    context 'Not Ownerの場合はアクセスできないこと' do
      let(:owner) { FactoryGirl.create(:user) }
      before { bypass_rescue }
      it { expect { get :edit, {id: group.to_param} }.to raise_error(Group::NotGroupOwner) }
    end
  end

  describe "POST create" do
    let(:you) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.attributes_for(:group) }

    context "with valid params" do
      context "with login" do
        context 'Groupが1件増えていること' do
          before { login_as(you) }
          it { expect{ post :create, {group: group} }.to change(Group, :count).by(1) }
        end

        context 'group_url(:id)にリダイレクトすること' do
          let(:new) { assigns(:group) }
          before do
            login_as(you)
            post :create, {group: group}
          end
          it { response.should redirect_to(group_url(new)) }
        end

        context 'ownerは自分でかつ、group.userに登録されていること' do #fixme
          subject { assigns(:group) }

          before do
            login_as(you)
            post :create, {group: group}
          end

          it { subject.owner_user_id.should eq you.id }
          it { subject.users.should include you }
        end
      end

      context "without login" do
        before { bypass_rescue }
        it { expect { post :create, {group: group} }.to raise_error(User::UnAuthorized) }
      end
    end

    context "with invalid params" do
      before do
        login_as(you)
        Group.any_instance.stub(:save) { false }
        post :create, {group: {}}
      end

      it { response.should render_template("new") }
    end
  end

  describe "PUT update" do
    let!(:you) { FactoryGirl.create(:user) }
    let(:current) { FactoryGirl.create(:group, owner_user_id: owner.id) }

    before { login_as(you) }

    describe "with valid params" do
      let(:edited) { FactoryGirl.attributes_for(:group) }

      context "Ownerの場合は更新できること" do
        let(:owner) { you }

        context 'update_attributesが呼ばれていること' do
          before { Group.any_instance.should_receive(:update_attributes).with('these' => 'params') }
          it { put :update, {id: current.to_param, group: {'these' => 'params'}} }
        end

        context 'group_url(:id)にリダイレクトすること' do
          before { put :update, { id: current.to_param, group: edited } }
          it { response.should redirect_to(group_url(current)) }
        end
      end

      context "Not Ownerの場合は更新できないこと" do
        let(:owner) { FactoryGirl.create(:user) }
        before { bypass_rescue }
        it { expect { put :update, {id: current.to_param, group: edited} }.to raise_error(Group::NotGroupOwner) }
      end
    end

    describe "with invalid params" do
      let(:current) { FactoryGirl.create(:group, owner_user_id: you.id) }

      before do
        Group.any_instance.stub(:save) { false }
        put :update, {id: current.to_param, group: {}}
      end

      it { response.should render_template("edit") }
    end
  end

  describe "DELETE destroy" do
    let(:you) { FactoryGirl.create(:user) }
    let!(:group) { FactoryGirl.create(:group, owner_user_id: owner.id) }
    before do
      login_as(you)
      Group.any_instance.stub_chain(:users, :size){ 1 }
    end

    context 'Ownerの場合は削除できること' do
      let(:owner) { you }
      it { expect { delete :destroy, {id: group.to_param} }.to change(Group, :count).by(-1) }
      pending { response.should redirect_to(my_url) }
    end

    context 'Not Ownerの場合は削除できないこと' do
      let(:owner) { FactoryGirl.create(:user) }
      before { bypass_rescue }
      it { expect { delete :destroy, {id: group.to_param} }.to raise_error(Group::NotGroupOwner) }
    end
  end
end
