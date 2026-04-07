class UsersController < ApplicationController
  def new
    @user = User.new(free: true)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    permitted = params.require(:user).permit(:email, :password, :password_confirmation)
    permitted[:free] = false
    permitted[:advance] = false
    permitted[:pro] = false

    case params[:plan]
    when "advance"
      permitted[:advance] = true
    when "pro"
      permitted[:pro] = true
    else
      permitted[:free] = true
    end

    permitted
  end
end
