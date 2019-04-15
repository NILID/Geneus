FactoryBot.define do
  factory :person do
    name { 'Ivan' }
    bio  { 'About Ivan'}
    date_of_birth { DateTime.now - 20.years }
    date_of_death { DateTime.now - 2.years }
    gender { 'male' }
  end
end
