# coding: utf-8
require 'spec_helper'

describe GroupsPostsController do
  describe "GET 'index'" do
    subject { assigns(:posts) }

    let!(:group) { FactoryGirl.create(:group) }
    let!(:post_single)      { FactoryGirl.create(:post, group: group, idx: 5) }
    let!(:post_range_lower) { FactoryGirl.create(:post, group: group, idx: 10) }
    let!(:post_range_upper) { FactoryGirl.create(:post, group: group, idx: 20) }
    let!(:post_range_u_out) { FactoryGirl.create(:post, group: group, idx: 21) }

    # TODO rengeのスペルミスを直す renge -> range
    context 'allが指定されたとき' do
      before do
        get :index, group_id: group.id, renge: 'all'
      end

      # すべてのpostが検出されること
      it { should have(4).items }
      it { should include(post_single) }
      it { should include(post_range_lower) }
      it { should include(post_range_upper) }
      it { should include(post_range_u_out) }
    end

    context 'l+数字が指定されたとき' do
      before do
        get :index, group_id: group.id, renge: 'l2'
      end

      # 新しい2件のpostが検出されること
      it { should have(2).items }
      it { should_not include(post_single) }
      it { should_not include(post_range_lower) }
      it { should     include(post_range_upper) }
      it { should     include(post_range_u_out) }
    end

    context '範囲が指定されたとき' do
      before do
        get :index, group_id: group.id, renge: "#{post_range_lower.idx}-#{post_range_upper.idx}"
      end

      # 範囲内のpostが検出されること
      it { should have(2).items }
      it { should_not include(post_single) }
      it { should     include(post_range_lower) }
      it { should     include(post_range_upper) }
      it { should_not include(post_range_u_out) }
    end
    
    context '数値が指定されたとき' do
      before do
        get :index, group_id: group.id, renge: post_single.idx.to_s
      end

      # 指定されたpostだけが検出されること
      it { should have(1).items }
      it { should     include(post_single) }
      it { should_not include(post_range_lower) }
      it { should_not include(post_range_upper) }
      it { should_not include(post_range_u_out) }
    end
  end

  describe "POST 'create'" do
    subject { response }
    let!(:group) { FactoryGirl.create(:group) }
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user_group) { FactoryGirl.create(:user_group,group_id: group.id, user_id: user.id) }

    context '書き込み内容に記載があるとき' do
      before do
        session[:user_id] = user.id
        # FIXME このURLをどうにかできないかな。group.idが3つも出てくる
        #post :create, post: { text: Forgery::Basic.text, group_id: group.id }, id: group.id, group_id: group.id
        post :create, post: { text: Forgery::Basic.text }, group_id: group.id
      end

      it { should be_redirect }
      it { should redirect_to(group_posts_url(anchor: assigns(:post).idx)) }
    end
    
    context '書き込み内容に記載がないとき' do
      before do
        session[:user_id] = user.id
        post :create, post: { text: '' }, group_id: group.id
      end

      it { should be_success }
      it { should render_template('new') }
    end
  end
end
