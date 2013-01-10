# coding: utf-8
require 'spec_helper'

describe EventsController do
  describe "GET 'show'" do
    let(:event) { FactoryGirl.create(:event, group_id: group.id) }

    context 'グループがsecretではない時' do
      include_examples 'member of group' do
        let(:action) { get :show, id: event.to_param }
      end
      it { assigns(:comment).event_id.should eq event.id }
    end

    context 'グループがsecretの時' do
      include_examples 'member of secret group' do
        let(:action) { get :show, id: event.to_param }
      end
    end
  end

  describe "GET 'new'" do
    context 'グループがsecretではない時' do
      include_examples 'member of group' do
        let(:action) { get :new }
      end
      it { assigns(:event).group_id.should eq group.id }
    end

    context 'グループがsecretの時' do
      include_examples 'member of secret group' do
        let(:action) { get :new }
      end
    end
  end

  describe "GET 'edit'" do
    let(:event) { FactoryGirl.create(:event, group_id: group.id) }

    context 'グループがsecretではない時' do
      include_examples 'member of group' do
        let(:action) { get :edit, id: event.to_param }
      end
      it { assigns(:event).group_id.should eq group.id }
    end

    context 'グループがsecretの時' do
      include_examples 'member of secret group' do
        let(:action) { get :edit, id: event.to_param }
      end
    end
  end
end
