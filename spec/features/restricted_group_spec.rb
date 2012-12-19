# coding: utf-8
require 'spec_helper'

describe "RequestedGroups" do
  context "あなたがオーナーではないグループの場合" do
    include_context "twitter_login"
    let(:other) { FactoryGirl.create(:user) }
    let!(:group) { FactoryGirl.create(:group, owner_user_id: other.id, users: [other], permission: 1) }

    context "グループへ参加リクエストする" do
      before do
        visit group_path(group)
        click_link 'この部活への参加リクエストを送る'
      end

      it { page.should have_content('Requested.') }
    end

    context "リクエストをキャンセルする" do
      before do
        visit group_path(group)
        click_link 'この部活への参加リクエストを送る'
        click_link 'cancel request'
      end

      it { page.should have_content('Deleted request.') }
    end
  end

  context "あなたがオーナーのグループの場合" do
    include_context "twitter_login"
    let(:other) { FactoryGirl.create(:user) }
    let!(:request) { FactoryGirl.create(:member_request, user: other, group: group) }
    let!(:group) { FactoryGirl.create(:group, owner_user_id: you.id, users: [you], permission: 1) }

    before do
      visit group_path(group)
      click_link '参加リクエスト(1)'
    end

    context "許可する" do
      before do
        click_link 'confirm'
        within("h1") do
          click_link group.name
        end
      end
      it { page.should have_content(other.name) }
    end

    context "拒否する" do
      before do
        click_link 'reject'
        within("h1") do
          click_link group.name
        end
      end
      it { page.should_not have_content(other.name) }
    end
  end
end
