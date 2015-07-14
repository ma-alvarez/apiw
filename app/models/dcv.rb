class Dcv < ActiveRecord::Base
  has_one :status
  belongs_to :client

  def as_json(options = {})
	super(only:[:id,:cpu,:memory,:hard_disk,:bw_avg_in,:bw_avg_out,:bw_peak_in,
        :bw_peak_out,:public_ip_count,:ip_net_web,:ip_net_application,:ip_net_backend,
        :edge_high_availability])	
  end

  def create_response
	  if(self.valid?)
	 	  response = {result:"OK", message:"DCV created", id:self.id}
	  else
		  response = {result:"ERROR", mesage:self.errors.full_messages, id:""}
	  end
	  return response.as_json
  end

  def service_parameters
    {cpuCount:cpu, memGB:memory, storageGB:hard_disk, 
      bandwidthAvgIn:bw_avg_in, bandwidthPeakIn:bw_peak_in, bandwidthAvgOut:bw_avg_out,
      bandwidthPeakOut:bw_peak_out, publicIpCount:public_ip_count, ipNetWeb:ip_net_web,
      ipNetApplication:ip_net_application, ipNetBackend:ip_net_backend,
      edgeHA:edge_high_availability}.to_query
  end

end
