class User < ActiveRecord::Base
  attr_accessible :email, :state
  store :stats, accessors: [ :share_clicks, :referals ]

  validates :email, :presence => true, :uniqueness => true, :format => {:with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i}

  # Range is from STATES (see below)
  validates :state, :presence => true, :inclusion => 0..1
  STATES = {:requested => 0, :invited => 1}

  def increment_stat statName
    value = self.stats[statName]
    value = 0 if value.nil?
    value += 1
    self.stats[statName] = value
    return self.save
  end
end
