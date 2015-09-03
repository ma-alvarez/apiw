class DcvsController < ApplicationController

  VRA_TREEBASE =  "OU=Clientes Externos,OU=vRealize Automation,DC=int,DC=fibercorp,DC=com,DC=ar"
  before_filter :set_client
  before_action :set_dcv, only: [:show, :update, :destroy, :status, :add_user, :pool_stats, :change_permissions]
  before_action :set_status, only: [:status, :update]
  before_action :set_user, only: [:create, :add_user, :change_permissions]

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
      render json: @dcv.as_json, status: :created, location: [@client,@dcv]
      response = VraServices.create_dcv(create_dcv_service_parameters)
      #se obtiene el token para salvar en el status, lo devuelve el VRA Service
      @status = @dcv.build_status
      @status.token = get_token(response) 
      @status.message = "creating dcv"
      @status.save 
    else
      render json: @dcv.errors, status: :unprocessable_entity
    end
  end

  def update
    if @dcv.update(update_dcv_params)
      head :no_content
      response = VraServices.update_dcv(update_dcv_service_parameters)
      @status.status = :working
      @status.token = get_token(response)
      @status.message = "updating dcv"
      @status.save 
    else
      render json: @dcv.errors, status: :unprocessable_entity
    end
  end

  def destroy
    ActiveDirectory.connect
    if ActiveDirectory.connection_ok?
      ActiveDirectory.remove_ou(client_name)
      @dcv.destroy
    end
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

  def change_permissions
    ActiveDirectory.connect
    if ActiveDirectory.connection_ok?
      ActiveDirectory.change_permissions(@user.username, client_name)
    end
    head :no_content
  end

  def disable
    head :no_content
  end

  def pool_stats
    response = VropServices.resource_pool_stats(client_name_parameters,stats_params)
    render json:response, status:response.code
  end

  def vm_stats
    response = VropServices.vm_stats(client_regex_parameters,stats_params)
    render json:response, status:200
  end

  private

    def set_client
      @client = Client.friendly.find(params[:client_id])
    end

    def set_dcv
      @dcv = @client.dcvs.find(params[:id])
    end

    def dcv_params
      params.permit(:id, :cpu,:memory,:hard_disk,:bw_avg_in,:bw_avg_out,:bw_peak_in,
        :bw_peak_out,:public_ip_count,:ip_net_web,:ip_net_application,:ip_net_backend,
        :edge_high_availability,:user_id,:client_id,:admin,:service_type)
    end

    def update_dcv_params
      params.permit(:id,:cpu,:memory,:hard_disk,:service_type)
    end

    def set_status
      @status = @dcv.status
    end

    def set_user
      @user = @client.users.find(params[:user_id])
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
        begin:params["begin"], end:params["end"]}.to_query
    end

    def user_service_parameters
      {clientName:client_name}.to_query
    end

    def create_dcv_service_parameters
      { clientEmail:@user.email, clientLogin:@user.username, clientPassword:@user.password,
        clientName:client_name, cpuCount:@dcv.cpu, memGB:@dcv.memory, storageGB:@dcv.hard_disk, 
      bandwidthAvgIn:@dcv.bw_avg_in, bandwidthPeakIn:@dcv.bw_peak_in, bandwidthAvgOut:@dcv.bw_avg_out,
      bandwidthPeakOut:@dcv.bw_peak_out, publicIpCount:@dcv.public_ip_count, ipNetWeb:@dcv.ip_net_web,
      ipNetApplication:@dcv.ip_net_application, ipNetBackend:@dcv.ip_net_backend,
      edgeHA:@dcv.edge_high_availability, serviceType:@dcv.service_type.camelize(:lower)}.to_query
    end

    def update_dcv_service_parameters
      { clientName:client_name, serviceType:@dcv.service_type.camelize(:lower), cpuCount:@dcv.cpu,
        memGB:@dcv.memory, storageGB:@dcv.hard_disk}.to_query
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
      if response["string"]["failed"]
        @status.status = 2
        @status.message = response["string"].partition("failed:")[2]
      end
      @status.save
    end
end
