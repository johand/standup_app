require 'rails_helper'

RSpec.describe "standups/index", type: :view do
  before(:each) do
    assign(:standups, [
      Standup.create!(
        user: nil
      ),
      Standup.create!(
        user: nil
      )
    ])
  end

  it "renders a list of standups" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
