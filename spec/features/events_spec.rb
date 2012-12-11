# coding: utf-8
require 'spec_helper'

describe "Events" do
  include_context "twitter_login"

  describe "GET /events/new" do
    let(:title){'event title 1'}
    include_context 'visit_group'
    before do
      visit new_event_path
      fill_in 'event[title]', with: title
      click_on 'Save'
    end

    it { page.should have_content(title) }
  end

  describe "GET /events/1/edit" do
    let(:title){'event title 2'}
    include_context 'visit_event'

    before do
      visit edit_event_path(event)
      fill_in 'event[title]', with: title
      click_on 'Save'
    end
    it { page.should have_content(title) }
  end

  describe "DELETE /events/1" do
    include_context 'visit_event'
    before { click_link '削除' }
    it { page.should have_content(group.name) }
  end

  describe "GET /events/1/cansel" do
    include_context 'visit_event'
    before { click_link 'イベントを中止' }
    it { page.should have_content('This event is canceled!') }
  end

  describe "GET /events/1/attend" do
    include_context 'visit_event'
    before { click_link '出席する' }
    it { page.should have_content('あなたの出欠 : 出席') }
  end

  describe "GET /events/1/absent" do
    include_context 'visit_event'
    before { click_link '欠席する' }
    it { page.should have_content('あなたの出欠 : 欠席') }
  end

  describe "GET /events/1/maybe" do
    include_context 'visit_event'
    before { click_link '微妙' }
    it { page.should have_content('あなたの出欠 : 微妙') }
  end

  describe "GET /events/1/delete" do
    include_context 'visit_event'
    before do
      click_link '出席する'
      click_link '取り消し'
    end
    it { page.should have_content('あなたの出欠 : 未入力') }
  end
end
