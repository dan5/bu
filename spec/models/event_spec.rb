# coding: utf-8
require 'spec_helper'

describe Event do
  describe "Validations" do
    it { should validate_presence_of(:title) }
    it { should ensure_length_of(:title).is_at_most(32) }
  end

  describe "Associations" do
    it { should belong_to(:group) }
    it { should have_many(:comments) }
    it { should have_many(:users).through(:user_events) }
  end

  describe '.be_ended_all' do
    let(:group) { FactoryGirl.create(:group, limit: 1) }
    let!(:events) { FactoryGirl.create_list(:event, 9, started_at: 1.day.ago, ended_at: 1.week.ago) }
    let!(:unclosed_events) { FactoryGirl.create_list(:event, 11, started_at: 1.day.since, ended_at: 1.week.since) }

    before do
      @count = 0
      Event.any_instance.stub(:be_ended) { @count += 1 }
      Event.be_ended_all
    end

    subject { @count }

    it 'close対象のeventの数だけ処理されていること' do
      should be events.count
    end
  end

  describe '.be_ended' do
    let(:group) { FactoryGirl.create(:group) }
    let(:event) { FactoryGirl.create(:event, group_id: group.id, limit: 1) }
    let(:you) { FactoryGirl.create(:user) }
    let(:other) { FactoryGirl.create(:user) }

    before do
      [you, other].each do |user|
        FactoryGirl.create(:user_event, user_id: user.id, event_id: event.id, state: 'attendance')
      end

      event.be_ended
    end

    it 'endedがtrueになること' do
      event.ended.should be_true
    end
  end
end
