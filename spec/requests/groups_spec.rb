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

  describe "GET /groups/new" do
    before do
      visit new_group_path
    end
    it { page.should have_xpath('//*[@id="group_name"]') }
  end
end
