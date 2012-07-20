class AddStatsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stats, :text
  end
end
