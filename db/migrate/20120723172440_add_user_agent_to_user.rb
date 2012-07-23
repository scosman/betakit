class AddUserAgentToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_agent, :string
  end
end
