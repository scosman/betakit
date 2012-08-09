class RenameCohort < ActiveRecord::Migration
  def change
    rename_column :statistics, :cohort_value, :cohort_group 
  end
end
