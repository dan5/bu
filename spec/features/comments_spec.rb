# coding: utf-8
require 'spec_helper'

describe "Events" do
  let!(:group) { FactoryGirl.create(:group) }
  include_context "twitter_login"

  before do
    Group.any_instance.stub(:member?).and_return( true )
    Group.any_instance.stub(:manager?).and_return( true )
  end

  include_context 'visit_current_event'

  describe 'POST /comments' do
    let(:comment) { FactoryGirl.attributes_for(:comment) }
    before do
      fill_in 'comment[text]', with: comment[:text]
      click_on 'Save'
    end

    it { page.should have_content(comment[:text]) }
  end

  describe 'GET /comment/:id' do
    let(:comment) { FactoryGirl.create(:comment, user: user) }
    before { visit comment_path(comment.id) }
    it { page.should have_content(comment[:text]) }
  end
end
