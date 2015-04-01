module SessionsHelper

	#Logs in the given user.
	#Temporary cookies created using the session method
	#below are automatically encrypted.
	def log_in(user)
		session[:user_id] = user.id
	end

	# Remember a user in a persistent session.
	def remember(user)
		# Creates token and saves remember_digest to db.
		user.remember
		# Creates permanent cookies for encrypted user_id and remember token.
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	#Returns true if the given user is the current user.
	def current_user?(user)
		user == current_user
	end

	#Returns the user corresponding to the temporary session cookie (if it exists)
	#or the signed permament user id cookie (if it exists, i.e. the user chose
	#"remember me" when last signing in.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

	#Returns true if the user is logged in, false otherwise.
	def logged_in?
		!current_user.nil?
	end

	# Forgets a persistent session.
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	#Logs out the current user
	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	#Redirects to stored location (or to the default).
	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	#Stores the URL trying to be accessed.
	def store_location
		#creates temporary cookie w/ key :forwarding_url whose
		#value is the url you are trying to access
		session[:forwarding_url] = request.url if request.get?
	end
end
