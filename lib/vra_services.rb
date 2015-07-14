module	VraServices
  include HTTParty
  BASE_URL = "http://10.120.85.85//api/service.asmx"
  CREATE_DCV_URI = "/AltaClienteDCV?"

  def self.create_dcv(params)
  	url = BASE_URL + CREATE_DCV_URI + params 
  	#return token
  end
end