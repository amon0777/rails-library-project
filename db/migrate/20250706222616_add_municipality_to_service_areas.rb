class AddMunicipalityToServiceAreas < ActiveRecord::Migration[8.0]
  def change
    add_column :service_areas, :municipality, :string
  end
end
