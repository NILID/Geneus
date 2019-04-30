class Parentship < ApplicationRecord
  after_update :manage_partner

  belongs_to :person
  belongs_to :father, class_name: 'Person', foreign_key: 'father_id', required: false
  belongs_to :mother, class_name: 'Person', foreign_key: 'mother_id', required: false

  validates_presence_of :person
  validate :cannot_be_own_parent

  def cannot_be_own_parent
    if person == mother || person == father
      errors.add(:base, 'Cannot add a person as their own parent or child.')
    end
  end

  private

  def manage_partner
    if father && mother
      father.partnerships.create! partner: mother unless father.partners.include? mother
    end
  end
end
