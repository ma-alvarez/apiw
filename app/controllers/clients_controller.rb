class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :update, :destroy]

  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all
    render json: @clients.as_json
  end

  # GET /clients/{:cuit}
  # GET /clients/1.json
  def show
    render json: @client.as_json
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    if @client.save
      render json: @client.as_json, status: :created, location: @client
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    #@client = Client.find(params[:id])

    if @client.update(client_params)
      head :no_content
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy

    head :no_content
  end

  private

    def set_client
      @client = Client.friendly.find(params[:id])
    end

    def client_params
      params.permit(:name, :cuit)
    end
end
