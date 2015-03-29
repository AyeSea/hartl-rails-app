module SessionsHelper

	#Logs in the given user.
	#Temporary cookies created using the session method
	#below are automatically encrypted.
	def log_in(user)
		session[:user_id] = user.id
	end

	#Returns the current logged-in user (if any), otherwise
	#defines the current user and returns it.
	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
	end

	#Returns true if the user is logged in, false otherwise.
	def logged_in?
		!current_user.nil?
	end
end
