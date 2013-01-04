# coding: utf-8
require 'spec_helper'
describe SettingsController do
  describe '#lanuage' do
    before do
      # redirect先の設定。 :backで指定しているため
      # HTTP_REFERERがないと落ちる
      @request.env['HTTP_REFERER'] = 'http://test.host/'
      get :language, language: :ja
    end
    it { session[:language].should eq 'ja' }
    it { response.should be_redirect }
    it { response.should redirect_to('/') }
  end

end

