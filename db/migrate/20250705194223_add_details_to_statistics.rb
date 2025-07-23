class AddDetailsToStatistics < ActiveRecord::Migration[8.0]
  def change
    add_column :statistics, :population, :integer
    add_column :statistics, :active_users_percent, :string
    add_column :statistics, :municipality, :string
    add_column :statistics, :bilingual, :boolean
    add_column :statistics, :northern, :boolean
  end
end
