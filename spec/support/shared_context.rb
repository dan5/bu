# coding: utf-8
shared_context "twitter_login" do
  let!(:you) { FactoryGirl.create(:user) }
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[you.provider.to_sym] = {
      "provider" => you.provider,
      "uid" => you.uid,
      'info' => {
        'email' => you.mail,
        'nickname' => you.name,
        'image' => you.image
      }
    }

    visit "/auth/twitter"
  end
end

shared_context "visit_event" do
  include_context 'visit_group'
  let(:event) { FactoryGirl.create(:event, group: group) }
  before do
    visit event_path(event)
  end
end

shared_context "visit_group" do
  let(:group) { FactoryGirl.create(:group, owner_user_id: you, users: [you]) }
  before { visit group_path(group) } #session[:group_id] に @group_idを代入するため
end
