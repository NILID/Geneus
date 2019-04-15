FactoryBot.define do
  factory :partnership do
    person  { nil }
    partner { nil }
    date_started { "2019-04-07" }
    date_ended   { "2019-04-07" }
  end
end
