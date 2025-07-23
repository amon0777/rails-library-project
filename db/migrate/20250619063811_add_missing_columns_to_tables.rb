class AddMissingColumnsToTables < ActiveRecord::Migration[8.0]
  def change
   add_column :libraries, :bilingual, :boolean, default: false
    add_column :libraries, :northern, :boolean, default: false
    add_column :libraries, :population, :integer, default: 0
    
    add_column :service_areas, :population, :integer, default: 0
    
    add_column :statistics, :percentage, :decimal, precision: 5, scale: 2
  end
end
