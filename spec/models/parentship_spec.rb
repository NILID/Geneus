require 'rails_helper'

RSpec.describe Parentship, type: :model do

  let(:parentship) { build(:parentship) }

  it 'must be valid' do
    expect(parentship.valid?).to be true
    expect(parentship.errors).to be_empty
  end

  it 'must have person' do
    parentship.person = nil
    expect(parentship.valid?).to be false
    expect(parentship.errors[:person]).not_to be_empty
  end

  it 'person cannot be as own mother' do
    parentship.mother = parentship.person
    expect(parentship.valid?).to be false
    expect(parentship.errors[:base]).not_to be_empty
  end

  it 'person cannot be as own father' do
    parentship.father = parentship.person
    expect(parentship.valid?).to be false
    expect(parentship.errors[:base]).not_to be_empty
  end
end
