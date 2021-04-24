class Api::V1::UsersController < ApplicationController
  # GET /users/1
  def show
    if current_user
        render json: current_user.show_user
      else
        render json: {
            error: 'not signed in'
        }, status: 400
      end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit(:user_name, :email, :password, :password_confirmation)
    end
end
