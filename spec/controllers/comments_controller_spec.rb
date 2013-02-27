# coding: utf-8
require 'spec_helper'

describe CommentsController do
  describe "GET show" do
    let(:comment) { FactoryGirl.create(:comment) }
    before { get :show, id: comment.to_param }
    it { assigns(:comment).should eq comment }
  end

  describe "POST create" do
    let(:you) { FactoryGirl.create(:user) }

    context 'グループメンバーの場合' do
      let(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }
      let!(:event) { FactoryGirl.create(:event, group_id: group.id) }
      let(:comment) { FactoryGirl.attributes_for(:comment, event_id: event.id) }

      before { login_as(you) }

      context 'valid params' do
         before { post :create, {:comment => comment} }
         it { response.should redirect_to(assigns(:comment).event) }
       end

      context 'invalid params' do
        before do
          Comment.any_instance.should_receive(:save) { false }
          post :create, {:comment => comment}
        end

        it { response.should render_template("new") }
      end
    end

    context 'グループメンバーではない場合' do
      let(:group) { FactoryGirl.create(:group, owner_user_id: other.id) }
      let!(:event) { FactoryGirl.create(:event, group_id: group.id) }
      let(:comment) { FactoryGirl.attributes_for(:comment, event_id: event.id) }
      let(:other) { FactoryGirl.create(:user) }

      before do
        login_as(you)
        bypass_rescue
      end

      it { expect{ post :create, comment: comment }.to raise_error(Group::NotGroupMember) }
    end
  end

  describe "DELETE destroy" do
    let!(:comment) { FactoryGirl.create(:comment) }
    it { expect { delete :destroy, id: comment.to_param }.to change(Comment, :count).by(-1) }
  end
end
