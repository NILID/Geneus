require 'rails_helper'

RSpec.describe "people/show", type: :view do
  before(:each) do
    @person = create(:person, name: 'Ivan')
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Ivan/)
  end
end
