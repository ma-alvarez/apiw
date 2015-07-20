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

  def add_user_parameters
    #Por default false
     { login:username, password:password, confirmPassowrd:password, isSupport:false}.to_query
  end
end
