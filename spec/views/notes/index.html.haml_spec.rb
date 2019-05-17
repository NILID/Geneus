require 'rails_helper'

RSpec.describe "notes/index", type: :view do
  before(:each) do
    @person = create(:person)
    @notes  = create_list(:note, 2, person: @person)
  end

  it "renders a list of notes" do
    render
    assert_select "tr>td", :text => "Note content".to_s, :count => 2
  end
end
