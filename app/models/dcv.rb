class Dcv < ActiveRecord::Base
  has_one :status
  belongs_to :client
  enum service_type: [ :reservation, :allocation, :pay_as_you_go ]

  def as_json(options = {})
	super(only:[:id,:cpu,:memory,:hard_disk,:bw_avg_in,:bw_avg_out,:bw_peak_in,
        :bw_peak_out,:public_ip_count,:ip_net_web,:ip_net_application,:ip_net_backend,
        :edge_high_availability])	
  end

  def service_type
    self.service_type.camelize(:lower)
  end

  def create_response
	  if(self.valid?)
	 	  response = {result:"OK", message:"DCV created", id:self.id}
	  else
		  response = {result:"ERROR", mesage:self.errors.full_messages, id:""}
	  end
	  return response.as_json
  end
  
end
