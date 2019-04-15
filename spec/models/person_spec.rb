require 'rails_helper'

RSpec.describe Person, type: :model do

  let(:person) { build(:person) }

  it 'must have gender' do
    person.gender = nil
    expect(person.valid?).to be false
    expect(person.errors[:gender]).not_to be_empty
  end

  it 'death must be after birth ' do
    person.date_of_birth = DateTime.now
    person.date_of_death = DateTime.now - 1.day
    expect(person.valid?).to be false
    expect(person.errors[:date_of_death]).not_to be_empty
  end

  it 'birth must be before current date ' do
    person.date_of_birth = DateTime.now + 1.day
    expect(person.valid?).to be false
    expect(person.errors[:date_of_birth]).not_to be_empty
  end

  it 'death must be before current date ' do
    person.date_of_death = DateTime.now + 1.day
    expect(person.valid?).to be false
    expect(person.errors[:date_of_death]).not_to be_empty
  end
end
