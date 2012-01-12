require 'spec_helper'

describe SettingsController do

  describe "GET 'language'" do
    it "returns http success" do
      get 'language'
      response.should be_success
    end
  end

end
