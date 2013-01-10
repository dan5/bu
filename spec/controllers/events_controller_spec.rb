# coding: utf-8
require 'spec_helper'

describe EventsController do
  describe "GET 'show'" do
    let!(:group) { FactoryGirl.create(:group) }
    let!(:event) { FactoryGirl.create(:event, group_id: group.id) }

    before { get :show, id: group.to_param }
    it { response.should be_success }
  end
end
