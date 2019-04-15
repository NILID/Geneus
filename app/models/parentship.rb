class Parentship < ApplicationRecord
  belongs_to :person
  belongs_to :father, :class_name => 'Person', foreign_key: 'father_id', required: false
  belongs_to :mother, :class_name => 'Person', foreign_key: 'mother_id', required: false
end
