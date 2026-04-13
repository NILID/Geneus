class AddFamilyChartIntegrityConstraints < ActiveRecord::Migration[5.2]
  def change
    # add_index :parentships, :person_id, unique: true

    add_foreign_key :parentships, :people, column: :person_id
    add_foreign_key :parentships, :people, column: :father_id
    add_foreign_key :parentships, :people, column: :mother_id
    add_foreign_key :partnerships, :people, column: :partner_id
  end
end
