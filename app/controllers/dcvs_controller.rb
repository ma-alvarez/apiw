class DcvsController < ApplicationController
  include ActiveDirectory
  include VraServices

  VRA_TREEBASE =  "OU=Clientes Externos,OU=vRealize Automation,DC=int,DC=fibercorp,DC=com,DC=ar"
  before_filter :set_client
  before_action :set_dcv, only: [:show, :update, :destroy, :status, :add_user]
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
      response = VraServices.create_dcv(dcv_service_parameters)
      #se obtiene el token para salvar en el status, lo devuelve el VRA Service
      @status = @dcv.build_status
      @status.token = get_token(response) 
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
    response = VraServices.get_status(token_service_parameters)
    decide_status(response)
    render json: @status.as_json(only:[:status,:message])
  end

  def add_user
    response = VraServices.add_user(add_user_service_parameters)
    render nothing:true, status: response.code
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

    def dcv_service_parameters
      { clientEmail:@user.email, clientLogin:@user.username, clientPassword:@user.password,
        clientName:client_name, cpuCount:@dcv.cpu, memGB:@dcv.memory, storageGB:@dcv.hard_disk, 
      bandwidthAvgIn:@dcv.bw_avg_in, bandwidthPeakIn:@dcv.bw_peak_in, bandwidthAvgOut:@dcv.bw_avg_out,
      bandwidthPeakOut:@dcv.bw_peak_out, publicIpCount:@dcv.public_ip_count, ipNetWeb:@dcv.ip_net_web,
      ipNetApplication:@dcv.ip_net_application, ipNetBackend:@dcv.ip_net_backend,
      edgeHA:@dcv.edge_high_availability}.to_query
    end

    def add_user_service_parameters
      @user.add_user_parameters + "&" + @client.user_service_parameters
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
