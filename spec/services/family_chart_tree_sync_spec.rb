require 'rails_helper'

RSpec.describe FamilyChartTreeSync do
  describe '#call' do
    let!(:father) { create(:person, name: 'John Doe', gender: 'male') }
    let!(:mother) { create(:person, name: 'Jane Doe', gender: 'female') }
    let!(:child) { create(:person, name: 'Bob Doe', gender: 'male') }

    before do
      child.parentship.update!(father: father, mother: mother)
      father.partnerships.create!(partner: mother)
    end

    it 'updates person attributes from chart data' do
      nodes = [
        {
          'id' => father.id.to_s,
          'data' => { 'gender' => 'M', 'first name' => 'John', 'last name' => 'Doe Updated' },
          'rels' => { 'spouses' => [mother.id.to_s], 'children' => [child.id.to_s] }
        },
        {
          'id' => mother.id.to_s,
          'data' => { 'gender' => 'F', 'first name' => 'Jane', 'last name' => 'Doe' },
          'rels' => { 'spouses' => [father.id.to_s], 'children' => [child.id.to_s] }
        },
        {
          'id' => child.id.to_s,
          'data' => { 'gender' => 'M', 'first name' => 'Bob', 'last name' => 'Doe' },
          'rels' => { 'parents' => [father.id.to_s, mother.id.to_s] }
        }
      ]

      described_class.new(nodes: nodes, removed_ids: []).call

      expect(father.reload.name).to eq('John Doe Updated')
    end

    it 'creates a new person with chart_id for UUID ids' do
      uuid = 'aaaaaaaa-bbbb-4ccc-dddd-eeeeeeeeeeee'
      nodes = [
        {
          'id' => father.id.to_s,
          'data' => { 'gender' => 'M', 'first name' => 'John', 'last name' => 'Doe' },
          'rels' => { 'spouses' => [mother.id.to_s], 'children' => [child.id.to_s] }
        },
        {
          'id' => mother.id.to_s,
          'data' => { 'gender' => 'F', 'first name' => 'Jane', 'last name' => 'Doe' },
          'rels' => { 'spouses' => [father.id.to_s], 'children' => [child.id.to_s] }
        },
        {
          'id' => child.id.to_s,
          'data' => { 'gender' => 'M', 'first name' => 'Bob', 'last name' => 'Doe' },
          'rels' => { 'parents' => [father.id.to_s, mother.id.to_s] }
        },
        {
          'id' => uuid,
          'data' => { 'gender' => 'F', 'first name' => 'New', 'last name' => 'Person' },
          'rels' => {}
        }
      ]

      expect {
        described_class.new(nodes: nodes, removed_ids: []).call
      }.to change(Person, :count).by(1)

      expect(Person.find_by(chart_id: uuid).name).to eq('New Person')
    end

    it 'removes a person when listed in removed_ids' do
      nodes = [
        {
          'id' => father.id.to_s,
          'data' => { 'gender' => 'M', 'first name' => 'John', 'last name' => 'Doe' },
          'rels' => { 'spouses' => [mother.id.to_s] }
        },
        {
          'id' => mother.id.to_s,
          'data' => { 'gender' => 'F', 'first name' => 'Jane', 'last name' => 'Doe' },
          'rels' => { 'spouses' => [father.id.to_s] }
        }
      ]

      expect {
        described_class.new(nodes: nodes, removed_ids: [child.id.to_s]).call
      }.to change(Person, :count).by(-1)

      expect(Person.find_by(id: child.id)).to be_nil
    end
  end
end
