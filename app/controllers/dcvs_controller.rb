class DcvsController < ApplicationController

  VRA_TREEBASE =  "OU=Clientes Externos,OU=vRealize Automation,DC=int,DC=fibercorp,DC=com,DC=ar"
  before_filter :set_client
  before_action :set_dcv, only: [:show, :update, :destroy, :status, :add_user, :pool_stats]
  before_action :set_status, only: [:status]
  before_action :set_user, only: [:create, :add_user]

  def index
    @dcvs = @client.dcvs
    render json: @dcvs.as_json
  end

  def show
    render json: @dcv.as_json
  end

  def create
    #Chequear si existe usuario LDAP, si existe llamar al servicio nuevo
    #si no existe llamar al servicio de siempre (AltaClienteDCV)
    params.delete("user_id")
    @dcv = @client.dcvs.new(dcv_params)

    if @dcv.save
      render json: @dcv.create_response, status: :created, location: [@client,@dcv]
      #se obtiene el token para salvar en el status, lo devuelve el VRA Service
      @status = @dcv.build_status
      @status.token = "yDjknsi282jJioqpzDok23899ddiaqSnvO" 
      @status.message = "creating dcv"
      @status.save 
    else
      render json: @dcv.create_response, status: :unprocessable_entity
    end
  end

  def update
    if @dcv.update(dcv_params)
      head :no_content
    else
      render json: @dcv.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @dcv.destroy
    head :no_content
  end

  def status
    #consultar estado con el Web Service y actualizarlo en BD PostgreSQL
    # response = VraServices.get_status(token_service_parameters)
    # decide_status(response)
    render json: @status.as_json(only:[:status,:message])
  end

  def add_user
    # response = VraServices.add_user(add_user_service_parameters)
    render nothing:true, status: response.code
  end

  def pool_stats
    # response = VropServices.resource_pool_stats(client_name_parameters,stats_params)
    response = {
 "values": [
   {
     "resourceId": "bb1f8c22-9727-4733-b06a-97bf8b36ea05",
     "stat-list": {
       "stat": [
         {
           "timestamps": [
             1435719599999,
             1435805999999,
             1435892399999,
             1435978799999,
             1436065199999,
             1436151599999,
             1436237999999,
             1436324399999,
             1436410799999,
             1436497199999,
             1436583599999,
             1436669999999,
             1436756399999,
             1436842799999,
             1436929199999,
             1437015599999,
             1437101999999,
             1437188399999,
             1437274799999,
             1437361199999,
             1437447599999
           ],
           "statKey": {
             "key": "mem|usage_average"
           },
           "rollUpType": "AVG",
           "intervalUnit": {
             "quantifier": 1,
             "intervalType": "DAYS"
           },
           "data": [
             3.272455114457342,
             3.3880974335802927,
             3.407475895351834,
             3.3668662913971477,
             3.4064839424358473,
             3.3803917235798306,
             3.3708018213510513,
             3.356729784909026,
             3.4513239752915172,
             3.3777129699786506,
             3.4011904290980763,
             3.3965939175751476,
             3.4371384324298964,
             3.4858815338876514,
             3.4329706786407366,
             3.431293862206595,
             3.473910713361369,
             3.4526458722021847,
             3.4753647190001278,
             3.4968922817044787,
             3.4748699598842197
           ]
         },
         {
           "timestamps": [
             1435719599999,
             1435805999999,
             1435892399999,
             1435978799999,
             1436065199999,
             1436151599999,
             1436237999999,
             1436324399999,
             1436410799999,
             1436497199999,
             1436583599999,
             1436669999999,
             1436756399999,
             1436842799999,
             1436929199999,
             1437015599999,
             1437101999999,
             1437188399999,
             1437274799999,
             1437361199999,
             1437447599999
           ],
           "statKey": {
             "key": "cpu|usagemhz_average"
           },
           "rollUpType": "AVG",
           "intervalUnit": {
             "quantifier": 1,
             "intervalType": "DAYS"
           },
           "data": [
             72.05277770095401,
             89.1766203376982,
             76.63703701231215,
             79.12013892332713,
             81.04004632102118,
             82.52592604690128,
             83.71134254667494,
             85.94610927993827,
             86.995370388031,
             88.4949074851142,
             90.20856479803722,
             92.11134265528784,
             94.13148154152765,
             97.2303243610594,
             98.58796303802066,
             101.3593496927401,
             102.50231471326616,
             104.44606498877208,
             106.12037046750386,
             108.34166696336534,
             110.23773148324754
           ]
         }
       ]
     }
   }
 ]
}

    render json:response, status:200
  end

  def vm_stats
    # response = VropServices.vm_stats(client_regex_parameters,stats_params)
    response = {
   "values": [
     {
       "resourceId": "67ccea86-ff54-4a7b-8d04-a797a926252b",
       "stat-list": {
         "stat": [
           {
             "timestamps": [
               1435719599999,
               1435805999999,
               1435892399999,
               1435978799999,
               1436065199999,
               1436151599999,
               1436237999999,
               1436324399999,
               1436410799999,
               1436497199999,
               1436583599999,
               1436669999999,
               1436756399999,
               1436842799999,
               1436929199999,
               1437015599999,
               1437101999999,
               1437188399999,
               1437274799999,
               1437361199999,
               1437447599999
             ],
             "statKey": {
               "key": "mem|usage_average"
             },
             "rollUpType": "AVG",
             "intervalUnit": {
               "quantifier": 1,
               "intervalType": "DAYS"
             },
             "data": [
               6.164537029961745,
               6.1969444495108394,
               6.306666649050182,
               6.248564790520403,
               6.357592581874794,
               6.339537009596825,
               6.222870371407932,
               6.20486643173138,
               6.440462960965103,
               6.27171294308371,
               6.321481473743916,
               6.290231471260388,
               6.4036573933230505,
               6.5962499876817065,
               6.49578702615367,
               6.507073151525304,
               6.443240734438102,
               6.570787018371953,
               6.607592590153217,
               6.619166649878025,
               6.5765740556849375
             ]
           },
           {
             "timestamps": [
               1435719599999,
               1435805999999,
               1435892399999,
               1435978799999,
               1436065199999,
               1436151599999,
               1436237999999,
               1436324399999,
               1436410799999,
               1436497199999,
               1436583599999,
               1436669999999,
               1436756399999,
               1436842799999,
               1436929199999,
               1437015599999,
               1437101999999,
               1437188399999,
               1437274799999,
               1437361199999,
               1437447599999
             ],
             "statKey": {
               "key": "net|usage_average"
             },
             "rollUpType": "AVG",
             "intervalUnit": {
               "quantifier": 1,
               "intervalType": "DAYS"
             },
             "data": [
               0.00300925941620436,
               0.0025462964290959966,
               0.0032407409097585413,
               0.002314814935541815,
               0.0027777779226501784,
               0.0034722223774426514,
               0.0034722223774426514,
               0.006271777252702348,
               0.00324074088388847,
               0.002314814935541815,
               0.002314814935541815,
               0.004166666858105196,
               0.002314814935541815,
               0.0032407409097585413,
               0.002314814935541815,
               0.001858304394246809,
               0.0020833334419876337,
               0.002314814935541815,
               0.0037037038968669046,
               0.0020833334419876337,
               0.0032407409097585413
             ]
           },
           {
             "timestamps": [
               1435719599999,
               1435805999999,
               1435892399999,
               1435978799999,
               1436065199999,
               1436151599999,
               1436237999999,
               1436324399999,
               1436410799999,
               1436497199999,
               1436583599999,
               1436669999999,
               1436756399999,
               1436842799999,
               1436929199999,
               1437015599999,
               1437101999999,
               1437188399999,
               1437274799999,
               1437361199999,
               1437447599999
             ],
             "statKey": {
               "key": " diskspace|used"
             },
             "rollUpType": "AVG",
             "intervalUnit": {
               "quantifier": 1,
               "intervalType": "DAYS"
             },
             "data": [
               2.78171296003792,
               4.003472235467699,
               3.868287048406071,
               2.6680555567145348,
               2.7442129626870155,
               2.700925930920574,
               2.548148148175743,
               2.5939605132212624,
               2.670833334326744,
               2.683101851079199,
               2.340972222801712,
               3.8215278080768056,
               4.018055510189798,
               3.1025462970137596,
               2.8613425886465444,
               3.0425087068139054,
               2.6335648145112724,
               2.750462953415182,
               2.7990740773578486,
               2.943981478611628,
               2.417129624634981
             ]
           },
           {
             "timestamps": [
               1435719599999,
               1435805999999,
               1435892399999,
               1435978799999,
               1436065199999,
               1436151599999,
               1436237999999,
               1436324399999,
               1436410799999,
               1436497199999,
               1436583599999,
               1436669999999,
               1436756399999,
               1436842799999,
               1436929199999,
               1437015599999,
               1437101999999,
               1437188399999,
               1437274799999,
               1437361199999,
               1437447599999
             ],
             "statKey": {
               "key": "cpu|usagemhz_average"
             },
             "rollUpType": "AVG",
             "intervalUnit": {
               "quantifier": 1,
               "intervalType": "DAYS"
             },
             "data": [
               37.76226845052507,
               39.36759255992042,
               42.12939804792404,
               44.53310179710388,
               45.942592587735916,
               47.93703691164652,
               49.442361169391205,
               50.295470267638095,
               52.19421288702223,
               54.33888898293177,
               55.98472227652868,
               57.8592591881752,
               59.79884256919225,
               62.85925926102532,
               64.24884263674419,
               66.88524982572017,
               68.23541668388579,
               69.96851847569148,
               71.87500002649095,
               73.95416671037674,
               75.91157430410385
             ]
           }
         ]
       }
     }
   ],
   "name": "Wetcom-001"
 }

    render json:response, status:200
  end

  private

    def set_client
      @client = Client.friendly.find(params[:client_id])
    end

    def set_dcv
      @dcv = Dcv.find(params[:id])
    end

    def dcv_params
      params.permit(:cpu,:memory,:hard_disk,:bw_avg_in,:bw_avg_out,:bw_peak_in,
        :bw_peak_out,:public_ip_count,:ip_net_web,:ip_net_application,:ip_net_backend,
        :edge_high_availability,:user_id,:client_id,:admin)
    end

    def set_status
      @status = Dcv.find(params[:id]).status
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def client_name
      @client.cuit + "-" + @client.name + "-" + @dcv.id.to_s
    end

    def client_name_parameters
      {name:client_name}.to_query
    end

    def client_regex_parameters
      {regex:'^' + client_name + '-\d{3}'}.to_query
    end

    def stats_params
      {intervalType:params["intervalType"], rollUpType:params["rollUpType"],
        "begin":params["begin"], "end":params["end"]}.to_query
    end

    def user_service_parameters
      {clientName:client_name}.to_query
    end

    def dcv_service_parameters
      { clientEmail:@user.email, clientLogin:@user.username, clientPassword:@user.password,
        clientName:client_name, cpuCount:@dcv.cpu, memGB:@dcv.memory, storageGB:@dcv.hard_disk, 
      bandwidthAvgIn:@dcv.bw_avg_in, bandwidthPeakIn:@dcv.bw_peak_in, bandwidthAvgOut:@dcv.bw_avg_out,
      bandwidthPeakOut:@dcv.bw_peak_out, publicIpCount:@dcv.public_ip_count, ipNetWeb:@dcv.ip_net_web,
      ipNetApplication:@dcv.ip_net_application, ipNetBackend:@dcv.ip_net_backend,
      edgeHA:@dcv.edge_high_availability}.to_query
    end

    def add_user_service_parameters
      @user.add_user_parameters + "&" + user_service_parameters
    end

    def token_service_parameters
      {tokenID:@dcv.status.token}.to_query
    end

    def get_token (response)
      response["string"]
    end

    def decide_status(response)
      if response["string"] == "completed"
        @status.status = 1
        @status.message = "DCV is ready"
      end
      if response["string"] == "failed"
        @status.status = 2
        @status.message = "error"
      end
      @status.save
    end
end
