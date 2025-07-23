class CreateServiceAreas < ActiveRecord::Migration[8.0]
  def change
    create_table :service_areas do |t|
      t.string :name
      t.references :library, null: false, foreign_key: true

      t.timestamps
    end
  end
end
