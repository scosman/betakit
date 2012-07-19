class AddStateToUser < ActiveRecord::Migration
  def change
    add_column :users, :state, :integer, :default => 0
  end
end
