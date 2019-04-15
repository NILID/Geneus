class CreatePartnerships < ActiveRecord::Migration[5.2]
  def change
    create_table :partnerships do |t|
      t.references :person,  foreign_key: true
      t.references :partner, foreign_key: false
      t.date :date_started
      t.date :date_ended
      t.string :nature
    end
  end
end
