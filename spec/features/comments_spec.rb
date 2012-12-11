# coding: utf-8
require 'spec_helper'

describe "Events" do
  include_context "twitter_login"
  include_context 'visit_event_page'

  describe 'POST /comments' do
    let(:comment) { FactoryGirl.attributes_for(:comment) }
    before do
      fill_in 'comment[text]', with: comment[:text]
      click_on 'Save'
    end

    it { page.should have_content(comment[:text]) }
  end

  describe 'GET /comment/:id' do
    let(:comment) { FactoryGirl.create(:comment, user: you) }
    before { visit comment_path(comment.id) }
    it { page.should have_content(comment[:text]) }
  end
end
