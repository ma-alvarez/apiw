class Svp < ActiveRecord::Base
  belongs_to :client

  def create_response
    if(self.valid?)
 	  response = {result:"OK", message:"SVP created", id:self.id}
    else
	  response = {result:"ERROR", mesage:self.errors.full_messages, id:""}
    end
    return response.as_json
  end
  
end
