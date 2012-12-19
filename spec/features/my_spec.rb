# coding: utf-8
require 'spec_helper'

describe "My" do
  include_context "twitter_login"

  describe "GET /my" do
    before { visit my_path }
    it { page.status_code.should eq 200 }

    context 'event exists' do
      include_context 'visit_event_page'
      before { visit my_path }
      it { page.should have_content(event.title) }
    end

    context 'group exists' do
      include_context 'visit_group_page'
      before { visit my_path }
      it { page.should have_content(group.name) }
    end
  end
end
