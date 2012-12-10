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
    let!(:event) { FactoryGirl.create(:event, group_id: group.id) }
    before do
      visit event_path(event)
      click_link '削除'
    end
    it { page.should have_content(group.name) }
  end
end
