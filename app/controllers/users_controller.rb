class UsersController < ApplicationController
  before_filter :set_client
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = @client.users
    render json: @users.as_json
  end

  def show
    render json: @user.as_json
  end

  def create
    @user = @client.users.new(user_params)

    if @user.save
      render json: @user.create_response, status: :created, location: [@client,@user]
    else
      render json: @user.create_response, status: :ok
    end
  end

  def update
    if @user.update(user_params)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    ActiveDirectory.connect
    if ActiveDirectory.connection_ok?
      ActiveDirectory.remove_user(@user.username)
      @user.destroy
    end
    head :no_content
  end

  def enable
    ActiveDirectory.connect
    if ActiveDirectory.connection_ok?
      ActiveDirectory.disable_user(@user.username)
    end
    head :no_content
  end

  def disable
    ActiveDirectory.connect
    if ActiveDirectory.connection_ok?
      ActiveDirectory.enable_user(@user.username)
    end
    head :no_content
  end

  private

    def set_client
      @client = Client.friendly.find(params[:client_id])
    end

    def set_user
      @user = @client.users.find(params[:id])
    end

    def user_params
      params.permit(:email,:password,:username)
    end
end
