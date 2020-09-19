require 'rails_helper'

RSpec.describe "standups/edit", type: :view do
  before(:each) do
    @standup = assign(:standup, Standup.create!(
      user: nil
    ))
  end

  it "renders the edit standup form" do
    render

    assert_select "form[action=?][method=?]", standup_path(@standup), "post" do

      assert_select "input[name=?]", "standup[user_id]"
    end
  end
end
