require 'rails_helper'

RSpec.describe "notes/edit", type: :view do
  before(:each) do
    @person = create(:person)
    @note   = create(:note, person: @person)
  end

  it "renders the edit note form" do
    render

    assert_select "form[action=?][method=?]", [@person, @note], "post" do

      assert_select "textarea[name=?]", "note[content]"
    end
  end
end
