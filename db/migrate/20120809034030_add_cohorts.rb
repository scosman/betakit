class AddCohorts < ActiveRecord::Migration
  def up
    remove_column :statistics, :cohort
    add_column :statistics, :cohort_name, :text
    add_column :statistics, :cohort_value, :text
    add_column :statistics, :sample_size, :integer
  end

  def down
    add_column :statistics, :cohort, :integer
    remove_column :statistics, :cohort_name, :text
    remove_column :statistics, :cohort_value, :text
    remove_column :statistics, :sample_size, :integer
  end
end
