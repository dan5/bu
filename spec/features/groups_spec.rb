# coding: utf-8
require 'spec_helper'

describe "Groups" do
  include_context "twitter_login"

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
    let!(:group) { FactoryGirl.attributes_for(:group) }
    before do
      visit new_group_path
      fill_in 'group[name]', with: group[:name]
      fill_in 'group[summary]', with: group[:summary]
      click_on 'Save'
    end
    it { page.should have_content(group[:name]) }
  end

  describe "GET /groups/1/edit" do
    let!(:group) { FactoryGirl.create(:group) }
    before do
      Group.any_instance.stub(:owner?).and_return( true )
      visit edit_group_path(group)
      fill_in 'group[name]', with: group.name
      fill_in 'group[summary]', with: group.summary
      click_on 'Save'
    end
    it { page.should have_content(group.name) }
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
