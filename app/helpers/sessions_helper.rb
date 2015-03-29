module SessionsHelper

	#Logs in the given user.
	#Temporary cookies created using the session method
	#below are automatically encrypted.
	def log_in(user)
		session[:user_id] = user.id
	end
end
