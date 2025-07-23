class RemoveActiveUsersPercentFromStatistics < ActiveRecord::Migration[8.0]
  def change
    remove_column :statistics, :active_users_percent, :string
  end
end
