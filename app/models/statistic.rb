class Statistic < ActiveRecord::Base
  attr_accessible :cohort_name, :cohort_group, :name, :time, :value, :sample_size

  validates :name, :presence => true
  validates :value, :presence => true
  validates :time, :presence => true
  validates :sample_size, :presence => true

  # both nil, or both populated
  validates :cohort_name, :presence => true, :unless => "cohort_group.nil?"
  validates :cohort_group, :presence => true, :unless => "cohort_name.nil?"

end
