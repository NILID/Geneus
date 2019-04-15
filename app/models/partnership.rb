class Partnership < ApplicationRecord
  belongs_to :person
  belongs_to :partner, :class_name => 'Person'

  after_create :create_inverse, unless: :inverse_exists?
  after_destroy :destroy_inverses, if: :inverse_exists?

  validates_presence_of :person, :partner
  validates_uniqueness_of :partner_id, :scope => :person_id, :message => 'already exists.'
  validate :cannot_add_self

  def cannot_add_self
    errors.add(:base, 'Cannot add a person as their own partner.') if self.person == self.partner
  end

  def partner_of_person(someone)
    return partner if someone == person
    return person  if someone == partner
    return false
  end

  def create_inverse
    self.class.create(inverse_partnership)
  end

  def destroy_inverses
    inverses.destroy_all
  end

  def inverse_exists?
    self.class.exists?(inverse_partnership)
  end

  def inverses
    self.class.where(inverse_partnership)
  end

  def inverse_partnership
    { partner_id: person_id, person_id: partner_id }
  end
end
