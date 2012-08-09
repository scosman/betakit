class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.string :name
      t.float :value
      t.integer :cohort
      t.timestamp :time

      t.timestamps
    end
  end
end
