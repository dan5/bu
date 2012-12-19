# coding: utf-8
require 'spec_helper'

describe "Users" do
  include_context "twitter_login"

  describe "GET /user/edit" do
    let(:new_user) do
      FactoryGirl.attributes_for(:user, name: Forgery::Basic.text, mail: Forgery::Email.address)
    end
    
    context 'すべての領域に値を入力' do
      before do
        visit users_edit_path
        fill_in 'user[name]', with: new_user[:name]
        fill_in 'user[mail]', with: new_user[:mail]
        click_on 'Save'
      end

      it { page.should have_content('User was successfully updated.') }
      it { page.should_not have_content('Please input your mail address') }
    end

    context 'name領域だけ入力されているとき' do
      before do
        visit users_edit_path
        fill_in 'user[name]', with: new_user[:name]
        fill_in 'user[mail]', with: ''
        click_on 'Save'
      end

      it 'Userの更新は失敗する？' do
        pending '仕様が不明なのですが、現状ではアップデートが成功します。これで良い？'
        page.should_not have_content('User was successfully updated.')
      end
      it { page.should have_content('Please input your mail address') }
    end
  end
end
