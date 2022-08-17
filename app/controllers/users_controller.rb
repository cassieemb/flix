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
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: "User account created successfully"
    else
      render :new, status: 422
    end
  end

  def edit
    @user = User.find_by(params[:id])
  end

  def update
    @user = User.find_by(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "User account updated successfully"
    else
      render :edit, status: 422
    end
  end

  def destroy
    @user = User.find_by(params[:id])
    @user.destroy
    session[:user_id] = nil
    redirect_to movies_url, alert: "User account deleted successfully"

  end

  private

  def user_params
    params.require(:user).
      permit(:name, :username, :email, :password, :password_confirmation)
  end
end

