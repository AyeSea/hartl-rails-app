class PasswordResetsController < ApplicationController
  before_action :get_user,   			 only: [:edit, :update]
  before_action :valid_user, 		   only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  # Renders form to initiate password reset. User is prompted for account email.
  def new
  end

  # Called when user submits email in form rendered by new action.
  # Creates password reset_digest & sends email w/ password reset instructions 
  # if user is found (i.e. their email exists in the db).
  def create
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
  	if @user
  		@user.create_reset_digest
  		@user.send_password_reset_email
  		flash[:info] = "Email sent with password reset instructions"
  		redirect_to root_url
  	else
  		flash.now[:danger] = "Email address not found"
  		render 'new'
  	end
  end

  # Renders form for selecting new password. Accessed through reset link
  # sent by the create action.
  def edit
  end

  # Resets password (updates value in db). Checks that new password isn't blank 
  # and passes validations specified in User model.
  def update
  	if password_blank?
  		flash.now[:danger] = "Password can't be blank."
  		render 'edit'
  	elsif @user.update_attributes(user_params)
  		log_in @user
  		flash[:success] = "Password has been reset."
  		redirect_to @user
  	else
  		render 'edit'
  	end
  end

  private

  	def user_params
  		params.require(:user).permit(:password, :password_confirmation)
  	end

  	# Returns true if password is blank.
  	def password_blank?
  		params[:user][:password].blank?
  	end

  	# Before filters

  	def get_user
  		@user = User.find_by(email: params[:email])
  	end

  	# Confirms a valid user.
  	def valid_user
  		unless (@user && @user.activated? &&
  						@user.authenticated?(:reset, params[:id]))
  			redirect_to root_url
  		end
  	end

  	# Checks expiration of reset token.
  	def check_expiration
  		if @user.password_reset_expired?
  			flash[:danger] = "Password reset has expired."
  			redirect_to new_password_reset_url
  		end
  	end
end

