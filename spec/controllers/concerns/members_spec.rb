# coding: utf-8
require 'spec_helper'

describe Members do
  include RSpec::Rails::ControllerExampleGroup

  controller do
    include Members
    def index
      render :nothing => true
    end
  end

  context '#join' do
    let(:you) { FactoryGirl.create(:user) }
    let!(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }
    let(:user) { FactoryGirl.create(:user) }
  end
end
