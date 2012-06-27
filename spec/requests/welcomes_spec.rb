# coding: utf-8
require 'spec_helper'

describe "Welcomes" do
  describe "GET /welcomes" do
    before { visit root_path }

    it { page.should have_content('Bu: beta') }

    describe "click new groups" do
      before { click_link "新しい部活を作る" }
      it { page.should have_content('Login') }
    end
  end
end
