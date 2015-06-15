class DcvsController < ApplicationController
  before_filter :set_client
  before_action :set_dcv, only: [:show, :update, :destroy, :status]


  def index
    @dcvs = @client.dcvs
    render json: @dcvs.as_json(only:[:id,:cpu,:memory,:hard_disk,:bandwidth,:status])
  end


  def show
    render json: @dcv.as_json(only:[:id,:cpu,:memory,:hard_disk,:bandwidth,:status])
  end

  def create
    @dcv = @client.dcvs.new(dcv_params)

    if @dcv.save
      render json: @dcv.as_json(only:[:id,:cpu,:memory,:hard_disk,:bandwidth,:status]), status: :created, location: [@client,@dcv]
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
    render json: @dcv.as_json(only:[:status]).merge(message:"example messasge")
  end

  private

    def set_client
      @client = Client.friendly.find(params[:client_id])
    end

    def set_dcv
      @dcv = Dcv.find(params[:id])
    end

    def dcv_params
      params.permit(:cpu,:memory,:hard_disk,:bandwidth)
    end
end
