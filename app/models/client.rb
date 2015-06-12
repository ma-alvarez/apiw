class Client < ActiveRecord::Base
  extend FriendlyId
  friendly_id :cuit, use: :slugged
  has_many :users
end
