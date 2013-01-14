# coding: utf-8
shared_context 'group exists' do
  let(:you) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group, owner_user_id: you.id) }

  before do
    @request.session[:group_id] = group.id
  end
end

shared_examples 'member of group' do
  include_context 'group exists'

  before do
    Group.any_instance.stub(:secret?) { false }
    action
  end
  it { response.should be_success }
end

shared_examples 'member of secret group' do
  include_context 'group exists'

  before do
    Group.any_instance.stub(:secret?) { true }
  end

  context 'memberはアクセスできる' do
    before do
      login_as(you)
      action
    end

    it { response.should be_success }
  end

  context 'not memberはアクセスできない' do
    let(:other) { FactoryGirl.create(:user) }

    before do
      login_as(other)
      bypass_rescue
    end

    it { expect{ action }.to raise_error(Group::NotGroupMember) }
  end
end
