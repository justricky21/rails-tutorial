module SessionsHelper

    def log_in(user)
        session[:user_id] = user.id
    end

    # user_id in this context is a newly created variable to store the session's or cookie's user id

    # Returns the user corresponding to the remember token cookie
    def current_user
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id])
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end

    # Forgets a persistent session

    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    def logged_in?
        !current_user.nil?
    end

    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end

    def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

end