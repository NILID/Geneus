class AddLocationsToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :location_of_birth, :string, default: nil
    add_column :people, :location_of_death, :string, default: nil
  end
end
