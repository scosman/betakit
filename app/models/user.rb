class User < ActiveRecord::Base
  attr_accessible :email

  validates :email, :presence => true, :uniqueness => true, :format => {:with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i}
end
