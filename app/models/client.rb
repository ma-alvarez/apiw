class Client < ActiveRecord::Base
  extend FriendlyId
  friendly_id :cuit, use: :slugged
  has_many :users
  has_many :dcvs
  has_many :svps
  validates :name, :cuit, presence:true
  validates :name, :cuit, uniqueness:true

  def create_response
  	if(self.valid?)
  		response = {result:"OK", message:"Client created", id:self.cuit}
  	else
  		response = {result:"ERROR", message:"", id:""}
  	end
  	return response.as_json
  end
    
end
