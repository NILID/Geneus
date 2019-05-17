require 'rails_helper'

RSpec.describe Note, type: :model do

  let(:note) { build(:note) }

  it 'must have content' do
    note.content = nil
    expect(note.valid?).to be false
    expect(note.errors[:content]).not_to be_empty
  end
end
