require 'rails_helper'

RSpec.describe "notes/new", type: :view do
  before(:each) do
    @person = create(:person)
    @note   = create(:note, person: @person)
  end

  it "renders new note form" do
    render
    assert_select "form[action=?][method=?]", person_note_path(@person, @note), "post" do
      assert_select "textarea[name=?]", "note[content]"
    end
  end
end
