require 'rails_helper'

RSpec.describe "notes/show", type: :view do
  before(:each) do
    @person = create(:person)
    @note   = create(:note, person: @person)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Note content/)
    expect(rendered).to match(//)
  end
end
