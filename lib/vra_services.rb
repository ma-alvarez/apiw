module	VraServices
  include HTTParty
  BASE_URL = "http://10.120.85.85/api/service.asmx"
  CREATE_DCV_URI = "/AltaClienteDCV?"
  ADD_USER = "/AltaUsuarioDCV?"
  GET_TOKEN = "/GetWorkflowExecutionStatus?"


  def self.create_dcv(params)
  	url = BASE_URL + CREATE_DCV_URI + params
  	response = HTTParty.get(url)
  end

  def self.add_user(params)
  	url = BASE_URL + ADD_USER + params
  	response = HTTParty.get(url)
  end

  def self.get_status(params)
  	url = BASE_URL + GET_TOKEN + params
  	response = HTTParty.get(url)
  end
  
end