# coding: utf-8
require 'spec_helper'

describe GroupsPostsController do
  describe "GET 'index'" do
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

      it 'すべてのpostが検出されること' do
        assigns(:posts).should have(4).items
        assigns(:posts).should include(post_single)
        assigns(:posts).should include(post_range_lower)
        assigns(:posts).should include(post_range_upper)
        assigns(:posts).should include(post_range_u_out)
      end
    end

    context 'l+数字が指定されたとき' do
      before do
        get :index, group_id: group.id, renge: 'l2'
      end

      it '新しい2件のpostが検出されること' do
        assigns(:posts).should have(2).items
        assigns(:posts).should_not include(post_single)
        assigns(:posts).should_not include(post_range_lower)
        assigns(:posts).should     include(post_range_upper)
        assigns(:posts).should     include(post_range_u_out)
      end
    end

    context '範囲が指定されたとき' do
      before do
        get :index, group_id: group.id, renge: "#{post_range_lower.idx}-#{post_range_upper.idx}"
      end

      it '範囲内のpostが検出されること' do
        assigns(:posts).should have(2).items
        assigns(:posts).should_not include(post_single)
        assigns(:posts).should     include(post_range_lower)
        assigns(:posts).should     include(post_range_upper)
        assigns(:posts).should_not include(post_range_u_out)
      end
    end
    
    context '数値が指定されたとき' do
      before do
        get :index, group_id: group.id, renge: post_single.idx.to_s
      end

      it '指定されたpostだけが検出されること' do
        assigns(:posts).should have(1).items
        assigns(:posts).should     include(post_single)
        assigns(:posts).should_not include(post_range_lower)
        assigns(:posts).should_not include(post_range_upper)
        assigns(:posts).should_not include(post_range_u_out)
      end
    end
  end

  describe "POST 'create'" do
    let!(:group) { FactoryGirl.create(:group) }
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user_group) { FactoryGirl.create(:user_group,group_id: group.id, user_id: user.id) }

    context '書き込み内容に記載があるとき' do
      before do
        session[:user_id] = user.id
        # FIXME このURLをどうにかできないかな。group.idが3つも出てくる
        post :create, post: { text: Forgery::Basic.text, group_id: group.id }, id: group.id, group_id: group.id
      end

      it 'リダイレクトすること' do
        response.should be_redirect
        response.should redirect_to(group_posts_url + "#" + assigns(:post).idx.to_s)
      end
    end
  end

end

