FactoryBot.define do
  factory :note do
    content { 'Note content' }
    person
  end
end
