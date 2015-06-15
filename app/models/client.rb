class Client < ActiveRecord::Base
  extend FriendlyId
  friendly_id :cuit, use: :slugged
  has_many :users
  has_many :dcvs
  validates :name, :cuit, presence:true
  validates :name, :cuit, uniqueness:true
end
