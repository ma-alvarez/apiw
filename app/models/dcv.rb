class Dcv < ActiveRecord::Base
	has_one :status

	def as_json(options = {})
		super(only:[:id,:cpu,:memory,:hard_disk,:bw_avg_in,:bw_avg_out,:bw_peak_in,
        :bw_peak_out,:public_ip_count,:ip_net_web,:ip_net_application,:ip_net_backend,
        :edge_high_availability])	
	end
end
