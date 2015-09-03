module	VraServices
  include HTTParty
  BASE_URL = "http://10.120.85.85/api/service.asmx"
  CREATE_DCV_URI = "/AltaClienteDCV?"
  UPDATE_DCV_URI = "/ActualizarReservacionClienteDCV?"
  CREATE_SVP_URI = "/AltaClienteSVP?"
  HANDLING_DCV_URI = "/HabilitarDeshabilitarClienteDCV?"
  ADD_USER = "/AltaUsuarioDCV?"
  GET_TOKEN = "/GetWorkflowExecutionStatus?"
  CUSTOMER_BASE_URL = "https://fc-vra.fibercorp.com.ar/catalog-service/api"
  LOGIN_URL = "https://fc-vra.fibercorp.com.ar/identity/api/tokens"
  CATALOG_ITEMS = "/consumer/entitledCatalogItems"
  REQUEST = "/consumer/requests"
  AUTH = {"username":"svp-admin@int.fibercorp.com.ar", "password":"F1b3rC*rp", 
    "tenant":"dchornos-svp-01"}.to_json


  def self.create_dcv(params)
  	url = BASE_URL + CREATE_DCV_URI + params
  	response = HTTParty.get(url)
  end

  def self.update_dcv(params)
    url = BASE_URL + UPDATE_DCV_URI + params
    response = HTTParty.get(url)
  end

  def self.handling_dcv(params)
    url = BASE_URL + HANDLING_DCV_URI + params
    response = HTTParty.get(url) 
  end

  def self.create_svp(params, svp_json)
    url = BASE_URL + CREATE_SVP_URI + params
    puts url
    HTTParty.get(url)
    svp_url = CUSTOMER_BASE_URL + REQUEST
    token = bearer_token
    response = HTTParty.post(svp_url,
      body: svp_json,
      verify:false,
      headers:{
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'Authorization' => token
        })
  end

  def self.add_user(params)
  	url = BASE_URL + ADD_USER + params
  	response = HTTParty.get(url)
  end

  def self.get_status(params)
  	url = BASE_URL + GET_TOKEN + params
  	response = HTTParty.get(url)
  end

  def self.catalog
    url = CUSTOMER_BASE_URL + CATALOG_ITEMS
    token = bearer_token
    response = HTTParty.get(url,
      verify:false,
      headers:{
        'Accept' => 'application/json',
        'Authorization' => token
        })
    catalog_items = []
    response["content"].each do |item|
      catalog_items << {name:item["catalogItem"]["name"],
        blueprint_id:item["catalogItem"]["id"]}
    end
    return catalog_items
  end

  private
    
    def self.bearer_token
      response = HTTParty.post(LOGIN_URL, body:AUTH, 
        verify:false, 
        headers:{'Content-Type' => 'application/json'})
      "Bearer " + response["id"]
    end
    
end