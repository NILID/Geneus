FactoryBot.define do
  factory :partnership do
    person
    association :partner, factory: :person
    date_started { "2019-04-07" }
    date_ended   { "2019-04-07" }
  end
end
