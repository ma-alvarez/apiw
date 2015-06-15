class Client < ActiveRecord::Base
  extend FriendlyId
  friendly_id :cuit, use: :slugged
  has_many :users
  validates :name, :cuit, presence:true
  validates :name, :cuit, uniquenness:true
end
