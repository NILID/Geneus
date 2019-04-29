require 'rails_helper'

RSpec.describe PeopleHelper, type: :helper do
  let!(:person) { create(:person) }

  it 'return default EMPTY for nil' do
    person.bio = nil
    expect(helper.show_or_empty(person.bio)).to eq(content_tag(:span, 'Empty', class: 'text-muted'))
  end

  it 'return default avatar for nil with specific gender' do
    expect(person.gender).to eq('male')
    expect(avatar_or_default(person)).to eq('missing_male.png')
  end

  it 'return default avatar for nil with specific gender for female' do
    person.gender = 'female'
    expect(avatar_or_default(person)).to eq('missing_female.png')
  end

end
