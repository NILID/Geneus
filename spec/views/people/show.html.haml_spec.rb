require 'rails_helper'

RSpec.describe "people/show", type: :view do
  before(:each) do
    @person = create(:person)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
