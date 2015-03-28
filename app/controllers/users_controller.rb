class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  	#uncomment below to debug in rails server (uses byebug gem)
  	#debugger
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end