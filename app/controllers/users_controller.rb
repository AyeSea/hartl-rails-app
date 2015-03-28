class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  	#uncomment below to debug in rails server (uses byebug gem)
  	#debugger
  end

  def new
  end
end
