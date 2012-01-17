require 'spec_helper'

describe "posts/edit.html.haml" do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :user_id => 1,
      :group_id => 1,
      :text => "MyText"
    ))
  end

  it "renders the edit post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => posts_path(@post), :method => "post" do
      assert_select "input#post_user_id", :name => "post[user_id]"
      assert_select "input#post_group_id", :name => "post[group_id]"
      assert_select "textarea#post_text", :name => "post[text]"
    end
  end
end
