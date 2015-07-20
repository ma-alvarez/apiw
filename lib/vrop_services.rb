module	VropServices
  include HTTParty
  BASE_URL = "https://fc-vrom.int.fibercorp.com.ar/suite-api/api"
  RESOURCE_URL = "/resources"
  RESOURCE_POOL_KIND = "?resourceKind=resourcePool"
  VM_KIND = "?resourceKind=VirtualMachine"
  AUTH = { username: "admin", password: "F1b3rC*rp" }
  STATS_URL = "/stats?statKey=cpu|usagemhz_average&statKey=mem|usage_average"

  def self.resource_pool_stats(params)
    pool_url = BASE_URL + RESOURCE_URL + RESOURCE_POOL_KIND + "&" + params
    pool_response = HTTParty.get(pool_url,
      basic_auth: AUTH,
      verify:false)
    pool_id = pool_response["resources"]["resource"]["identifier"]
    stats_url = BASE_URL + RESOURCE_URL + "/" + pool_id + STATS_URL
    stats_response = HTTParty.get(stats_url,
      basic_auth:AUTH,
      verify:false,
      headers:{'Accept' => 'application/json'})
    return stats_response
  end

  def self.vm_stats(params)
    vm_url = BASE_URL + RESOURCE_URL + VM_KIND + "&" + params
    vm_response = sHTTParty.get(vm_url,
      basic_auth: AUTH,
      verify:false)
  end

end