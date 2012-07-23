class User < ActiveRecord::Base
  attr_accessible :email, :state
  has_many :referrals, :class_name => "User", :foreign_key => "referer_id"
  belongs_to :referer, :class_name => "User"
  store :stats, accessors: [ :share_clicks, :referals ]

  validates :email, :presence => true, :uniqueness => true, :format => {:with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i}

  # Range is from STATES (see below)
  validates :state, :presence => true, :inclusion => 0..1
  STATES = {:requested => 0, :invited => 1}

  # Referral codes are a bit weird. They are just the id of the user, but for some reason
  # I'm so used to alpha-numeric ref codes, a lame ref=7 just doesn't feel right, so instead
  # use the following algo: referral code = hex(REFERRAL_START_VALUE + User.id)
  REFERRAL_START_VALUE = 45474
  def referral_code
    return (REFERRAL_START_VALUE + self.id).to_s(16)
  end
  def self.find_by_referral_code ref
    return nil if ref.nil?
    id = ref.to_i(16) - REFERRAL_START_VALUE
    return User.find_by_id id 
  end

  def increment_stat statName
    value = self.stats[statName]
    value = 0 if value.nil?
    value += 1
    self.stats[statName] = value
    return self.save
  end
end
