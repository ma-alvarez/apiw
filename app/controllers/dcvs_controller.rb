class DcvsController < ApplicationController
  before_filter :set_client
  before_action :set_dcv, only: [:show, :update, :destroy, :status]
  before_action :set_status, only: [:status]


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

    #clientName = client.cuit - client.name - dcvs.count + 1
    params.delete("user_id")
    @dcv = @client.dcvs.new(dcv_params)

    if @dcv.save
      render json: @dcv.create_response, status: :created, location: [@client,@dcv]
      
      #obtener token para salvar en el status
      @status = @dcv.build_status
      @status.token = token
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
    render json: @status.as_json(only:[:status,:message])
  end

  def add_user
    #llamar a AltaUsuarioDcv, si sale todo bien 200 sino error
    render nothing:true, status: 200
  end

  private

    def token
      20.times.map { [*'0'..'9', *'a'..'z'].sample }.join
    end

    def set_client
      @client = Client.friendly.find(params[:client_id])
    end

    def set_dcv
      @dcv = Dcv.find(params[:id])
    end

    def dcv_params
      params.permit(:cpu,:memory,:hard_disk,:bw_avg_in,:bw_avg_out,:bw_peak_in,
        :bw_peak_out,:public_ip_count,:ip_net_web,:ip_net_application,:ip_net_backend,
        :edge_high_availability,:user_id)
    end

    def set_status
      @status = Dcv.find(params[:id]).status
    end
end
