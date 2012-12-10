# coding: utf-8
require 'spec_helper'

describe "Events" do
  include_context "twitter_login"
  let!(:group) { FactoryGirl.create(:group) }

  before do
    visit "/auth/twitter"

    # group owner
    Group.any_instance.stub(:owner?).and_return( true )
    Group.any_instance.stub(:member?).and_return( true )
    # for add session[:group_id]
    visit group_path(group)
  end

  describe "GET /events/new" do
    let!(:title){'event title 1'}
    before do
      visit new_event_path
      fill_in 'event[title]', with: title
      click_on 'Save'
    end

    it { page.should have_content(title) }
  end

  describe "GET /events/1/edit" do
    let!(:title){'event title 2'}
    let!(:event) { FactoryGirl.create(:event, group_id: group.id) }

    before do
      visit edit_event_path(event)
      fill_in 'event[title]', with: title
      click_on 'Save'
    end
    it { page.should have_content(title) }
  end

  describe "DELETE /events/1" do
    include_context 'visit_current_event'
    before { click_link '削除' }
    it { page.should have_content(group.name) }
  end

  describe "GET /events/1/cansel" do
    include_context 'visit_current_event'
    before { click_link 'イベントを中止' }
    it { page.should have_content('This event is canceled!') }
  end

  describe "GET /events/1/attend" do
    include_context 'visit_current_event'
    before { click_link '出席する' }
    it { page.should have_content('あなたの出欠 : 出席') }
  end

  describe "GET /events/1/absent" do
    include_context 'visit_current_event'
    before { click_link '欠席する' }
    it { page.should have_content('あなたの出欠 : 欠席') }
  end

  describe "GET /events/1/maybe" do
    include_context 'visit_current_event'
    before { click_link '微妙' }
    it { page.should have_content('あなたの出欠 : 微妙') }
  end

  describe "GET /events/1/delete" do
    include_context 'visit_current_event'
    before do
      click_link '出席する'
      click_link '取り消し'
    end
    it { page.should have_content('あなたの出欠 : 未入力') }
  end
end
