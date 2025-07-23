class CreateStatistics < ActiveRecord::Migration[8.0]
  def change
    create_table :statistics do |t|
      t.references :service_area, null: false, foreign_key: true
      t.string :month
      t.integer :active_users

      t.timestamps
    end
  end
end
