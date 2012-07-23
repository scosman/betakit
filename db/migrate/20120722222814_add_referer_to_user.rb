class AddRefererToUser < ActiveRecord::Migration
  def change
    add_column :users, :referer_id, :integer
  end
end
