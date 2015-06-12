class UsersController < ApplicationController
  before_filter :set_client
  before_action :set_user, only: [:show, :update, :destroy]


  def index
    @users = @client.users
    render json: @users.as_json(only:[:id,:username])
  end


  def show
    render json: @user.as_json(only:[:id,:username])
  end

  def create
    @user = @client.users.new(user_params)

    if @user.save
      render json: @user, status: :created, location: [@client,@user]
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(client_params)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

    def set_client
      @client = Client.friendly.find(params[:client_id])
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:username)
    end
end
