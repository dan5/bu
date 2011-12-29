require 'spec_helper'

describe "events/edit.html.haml" do
  before(:each) do
    @event = assign(:event, stub_model(Event,
      :group_id => 1,
      :title => "MyString",
      :place => "MyString",
      :address => "MyString",
      :limit => 1
    ))
  end

  it "renders the edit event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => events_path(@event), :method => "post" do
      assert_select "input#event_group_id", :name => "event[group_id]"
      assert_select "input#event_title", :name => "event[title]"
      assert_select "input#event_place", :name => "event[place]"
      assert_select "input#event_address", :name => "event[address]"
      assert_select "input#event_limit", :name => "event[limit]"
    end
  end
end
