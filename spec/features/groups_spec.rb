# coding: utf-8
require 'spec_helper'

describe "Groups" do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:twitter] = {
      provider: 'twitter',
      uid: '12345678',
      'info' => {
        'email' => 'yokohamarb@example.org',
        'nickname' => 'yokohamarb',
        'image' => 'https://si0.twimg.com/profile_images/2268491806/anq8ftu9ceoxzik2h2wj.png'
      }
    }
    visit "/auth/twitter"
  end

  describe "GET /groups/1" do
    let!(:group) { FactoryGirl.create(:group) }
    before do
      Group.any_instance.stub(:owner?).and_return( true )
      visit group_path(group)
    end

    it { page.should have_content(group.name) }

    context "GET /group/1/edit" do
      before { click_link 'Edit' }
      it { page.current_path.should eq edit_group_path(group) }
    end

    context "DELETE /group/1" do
      before { click_link '__Destroy__' }
      it { page.current_path.should eq group_path(group) + '/destroy_confirm' }
    end
  end

  describe "GET /groups/new" do
    let!(:name){'Yokohama.rb'}
    before do
      visit new_group_path
      fill_in 'group[name]', with: name
      fill_in 'group[summary]', with: '横浜を中心とする…'
      click_on 'Save'
    end
    it { page.should have_content(name) }
  end

  describe "GET /groups/1/edit" do
    let!(:name){'Yokoshima.rb'}
    let!(:group) { FactoryGirl.create(:group) }
    before do
      Group.any_instance.stub(:owner?).and_return( true )
      visit edit_group_path(group)
      fill_in 'group[name]', with: name
      fill_in 'group[summary]', with: '横浜を中心とする…'
      click_on 'Save'
    end
    it { page.should have_content(name) }
  end

  describe "DELETE /groups/1" do
    let!(:group) { FactoryGirl.create(:group) }
    before do
      visit groups_path
      Group.any_instance.stub(:owner?).and_return( true )
      click_link 'Destroy'
    end
    it { page.should have_content('Group was successfully deleted.') }
  end
end
