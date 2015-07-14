class Client < ActiveRecord::Base
  extend FriendlyId
  friendly_id :cuit, use: :slugged
  has_many :users
  has_many :dcvs
  validates :name, :cuit, presence:true
  validates :name, :cuit, uniqueness:true

  def create_response
  	if(self.valid?)
  		response = {result:"OK", message:"Client created", id:self.cuit}
  	else
  		response = {result:"ERROR", mesage:self.errors.full_messages, id:""}
  	end
  	return response.as_json
  end

  def client_name
    self.cuit + "-" + self.name + "-" + (self.dcvs.count+1).to_s
  end

  def service_parameters
    {clientName:client_name}.to_query
  end
  
end
