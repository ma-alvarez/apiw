class User < ActiveRecord::Base
  validates :username,:email,:password, presence:true
  validates :username,:email, uniqueness:true

  def as_json(options = {})
	super(only:[:id,:email,:username,:admin])
  end

  def create_response
  	if(self.valid?)
		  response = {result:"OK", message:"User created", id:self.id}
	  else
		  response = {result:"ERROR", mesage:self.errors.full_messages, id:""}
	  end
	  return response.as_json
  end

  def dcv_service_parameters
    { clientEmail:email, clientLogin:username, clientPassword:password }.to_query
  end

  def add_user_parameters
     { login:username, clientPassword:login, password:password, confirmPassowrd:password, isSupport:false}
  end
end
