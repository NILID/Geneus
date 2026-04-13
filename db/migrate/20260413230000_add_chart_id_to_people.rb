class AddChartIdToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :chart_id, :string
    add_index :people, :chart_id, unique: true
  end
end
