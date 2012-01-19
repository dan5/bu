require 'spec_helper'

describe UserGroupsController do

  describe "GET 'update'" do
    it "returns http success" do
      get 'update'
      response.should be_success
    end
  end

end
