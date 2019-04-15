class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
#      t.references :father, foreign_key: true
#      t.references :mother, foreign_key: true
      t.string :name
      t.string :gender
      t.text :bio
      t.date :date_of_birth
      t.date :date_of_death

      t.timestamps
    end
  end
end
