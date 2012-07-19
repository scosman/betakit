class User < ActiveRecord::Base
  attr_accessible :email, :state

  validates :email, :presence => true, :uniqueness => true, :format => {:with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i}

  # Range is from STATES (see below)
  validates :state, :presence => true, :inclusion => 0..1
  STATES = {:requested => 0, :invited => 1}
end
