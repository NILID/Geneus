require 'rails_helper'

RSpec.describe Partnership, type: :model do

  let(:partnership) { build(:partnership) }

  it 'must be valid' do
    expect(partnership.valid?).to be true
    expect(partnership.errors).to be_empty
  end

  it 'must have person' do
    partnership.person = nil
    expect(partnership.valid?).to be false
    expect(partnership.errors[:person]).not_to be_empty
  end

  it 'must have partner' do
    partnership.partner = nil
    expect(partnership.valid?).to be false
    expect(partnership.errors[:partner]).not_to be_empty
  end

  it 'cannot be in partnership with himself' do
    partnership.partner = partnership.person
    expect(partnership.valid?).to be false
    expect(partnership.errors[:base]).not_to be_empty
  end
end
