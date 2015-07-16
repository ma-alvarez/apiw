module	VraServices
  include HTTParty
  BASE_URL = "http://10.120.85.85/api/service.asmx"
  CREATE_DCV_URI = "/AltaClienteDCV?"
  ADD_USER = "/AltaUsuarioDCV?"

  def self.create_dcv(params)
  	url = BASE_URL + CREATE_DCV_URI + params
  	puts url 
  	#return token
  end

  def self.add_user(params)
  	url = BASE_URL + ADD_USER + params
  	#sacar el puts
  	puts url
  	response = HTTParty.get(url)
  end
end