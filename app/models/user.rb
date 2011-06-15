# == Schema Information
# Schema version: 20110614113903
#
# Table name: users
#
#  id                :integer         not null, primary key
#  username          :string(255)
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  role_id           :integer
#  login             :string(255)     default("default"), not null
#  persistence_token :string(255)     default("0"), not null
#  perishable_token  :string(255)     default("0"), not null
#  login_count       :integer         default(0), not null
#  last_request_at   :datetime
#  current_login_at  :datetime
#  last_login_at     :datetime
#  current_login_ip  :string(255)
#  last_login_ip     :string(255)
#

class User < ActiveRecord::Base
  belongs_to :role

  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::MD5
  end

  validates :username , :presence => true, :length => { :minimum => 5} , :uniqueness => true
  validates :crypted_password, :presence => true
  validates :password_salt, :presence => true
  validates :role_id, :presence => true
end
