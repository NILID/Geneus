class Parentship < ApplicationRecord
  after_update :manage_partner
  belongs_to :person
  belongs_to :father, :class_name => 'Person', foreign_key: 'father_id', required: false
  belongs_to :mother, :class_name => 'Person', foreign_key: 'mother_id', required: false

  private

  def manage_partner
    father.partnerships.create! partner: mother
  end
end
