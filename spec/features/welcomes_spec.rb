# coding: utf-8
require 'spec_helper'

describe "Welcomes" do
  describe "GET /welcomes" do
    before { visit root_path }

    it { page.should have_content('Bu: beta') }
  end

  describe "click new groups" do
    before do
      visit root_path
      click_link "新しい部活を作る"
    end
    it { page.should have_content('Login') }
  end

  describe "listing groups" do
    include_context "twitter_login"
    include_context 'visit_group_page'
    before { visit root_path }
    it { page.should have_content(group.name) }
  end
end
