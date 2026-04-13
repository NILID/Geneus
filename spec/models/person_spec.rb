require 'rails_helper'

RSpec.describe Person, type: :model do

  let(:person) { build(:person) }

  it 'must have gender' do
    expect(person.valid?).to be true
    expect(person.errors).to be_empty
  end

  it 'must have gender' do
    person.gender = nil
    expect(person.valid?).to be false
    expect(person.errors[:gender]).not_to be_empty
  end

  it 'must have gender inclusion male/female' do
    person.gender = 'women'
    expect(person.valid?).to be false
    expect(person.errors[:gender]).not_to be_empty
  end

  it 'death must be after birth ' do
    person.date_of_birth = DateTime.now
    person.date_of_death = DateTime.now - 1.day
    expect(person.valid?).to be false
    expect(person.errors[:date_of_death]).not_to be_empty
    expect(person.errors[:date_of_birth]).not_to be_empty
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

  it 'name must have minimum 1 symbol' do
    person.name = ''
    expect(person.valid?).to be false
    expect(person.errors[:name]).not_to be_empty
  end

  describe '#family_chart_node' do
    let!(:father) { create(:person, name: 'Father Doe', gender: 'male') }
    let!(:mother) { create(:person, name: 'Mother Doe', gender: 'female') }
    let!(:child) { create(:person, name: 'Child Doe', gender: 'male') }

    before do
      child.parentship.update!(father: father, mother: mother)
      father.partnerships.create!(partner: mother)
    end

    it 'exports id, data and rels in family-chart format' do
      node = child.family_chart_node

      expect(node[:id]).to eq(child.id.to_s)
      expect(node[:data]['gender']).to eq('M')
      expect(node[:rels][:parents]).to contain_exactly(father.id.to_s, mother.id.to_s)
    end
  end
end
