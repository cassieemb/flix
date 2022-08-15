class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    if @user.save
      redirect_to user_path(@user), notice: "User account created successfully"
    else
      render :new, status: 422
    end
  end

  private

  def user_params
    params.require(:user).
      permit(:name, :email, :password, :password_confirmation)
  end
end
