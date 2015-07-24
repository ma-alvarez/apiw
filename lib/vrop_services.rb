module	VropServices
  include HTTParty
  BASE_URL = "https://fc-vrom.int.fibercorp.com.ar/suite-api/api"
  RESOURCE_URL = "/resources"
  RESOURCE_POOL_KIND = "?resourceKind=resourcePool"
  VM_KIND = "?resourceKind=VirtualMachine"
  AUTH = { username: "admin", password: "F1b3rC*rp" }
  STATS_URL = "/stats?statKey=cpu|usagemhz_average&statKey=mem|usage_average&"
  VM_STATS_URL = "/stats?statKey=cpu|usagemhz_average&statKey=mem|usage_average&statKey=net|usage_average&statKey=diskspace|used&"

  def self.resource_pool_stats(params,stats_params)
    pool_url = BASE_URL + RESOURCE_URL + RESOURCE_POOL_KIND + "&" + params
    pool_response = HTTParty.get(pool_url,
      basic_auth: AUTH,
      verify:false)
    pool_id = pool_response["resources"]["resource"]["identifier"]
    stats_url = BASE_URL + RESOURCE_URL + "/" + pool_id + STATS_URL + stats_params
    stats_response = HTTParty.get(stats_url,
      basic_auth:AUTH,
      verify:false,
      headers:{'Accept' => 'application/json'})
    return stats_response
  end

  def self.vm_stats(params,stats_params)
    vm_url = BASE_URL + RESOURCE_URL + VM_KIND + "&" + params
    vm_response = HTTParty.get(vm_url,
      basic_auth: AUTH,
      verify:false,
      headers:{'Accept' => 'application/json'})
      vm_ids = []
      vm_names = []
      vm_response["resourceList"].each{|vm| vm_ids << vm["identifier"]}
      vm_response["resourceList"].each{|vm| vm_names << vm["resourceKey"]["name"]}
      vm_stats_responses = []
      vm_ids.each_with_index do |id, index|
        vm_stats_url = BASE_URL + RESOURCE_URL + "/" + id + VM_STATS_URL + stats_params
        vm_stats_response = HTTParty.get(vm_stats_url,
          basic_auth:AUTH,
          verify:false,
          headers:{'Accept' => 'application/json'})
        vm_stats_responses << vm_stats_response.merge({name:vm_names[index]})
      end  
    return vm_stats_responses
  end

end