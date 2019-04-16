class CreateParentships < ActiveRecord::Migration[5.2]
  def change
    create_table :parentships do |t|
      t.belongs_to :person,  index: true
      t.belongs_to :father,  index: true
      t.belongs_to :mother,  index: true
    end
  end
end
