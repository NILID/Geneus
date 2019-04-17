FactoryBot.define do
  factory :parentship do
    person
    association :mother, factory: :person
    association :father, factory: :person
  end
end
