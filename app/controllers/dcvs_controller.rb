class DcvsController < ApplicationController
  before_filter :set_client
  before_action :set_dcv, only: [:show, :update, :destroy, :status]
  before_action :set_status, only: [:status]


  def index
    @dcvs = @client.dcvs
    render json: @dcvs.as_json(only:[:id,:cpu,:memory,:hard_disk,:bandwidth])
  end


  def show
    render json: @dcv.as_json(only:[:id,:cpu,:memory,:hard_disk,:bandwidth])
  end

  def create
    @dcv = @client.dcvs.new(dcv_params)

    if @dcv.save
      render json: @dcv.as_json(only:[:id,:cpu,:memory,:hard_disk,:bandwidth]), status: :created, location: [@client,@dcv]
      
      #Obtain token to save in status
      @status = @dcv.build_status
      @status.token = token
      @status.message = "creating dcv"
      @status.save 
    else
      render json: @dcv.errors, status: :unprocessable_entity
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
      params.permit(:cpu,:memory,:hard_disk,:bandwidth)
    end

    def set_status
      @status = Dcv.find(params[:id]).status
    end
end
