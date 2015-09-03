class Dcv < ActiveRecord::Base
  has_one :status
  belongs_to :client
  validates :service_type, inclusion: { in: %w(reservation allocation pay_as_you_go),
    message: "%{value} is not a valid service type" }

  def as_json(options = {})
	super(only:[:id,:cpu,:memory,:hard_disk,:bw_avg_in,:bw_avg_out,:bw_peak_in,
        :bw_peak_out,:public_ip_count,:ip_net_web,:ip_net_application,:ip_net_backend,
        :edge_high_availability, :service_type])	
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
