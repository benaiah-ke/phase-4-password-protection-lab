class SessionsController < ApplicationController

    def create
        user = User.find_by(username: login_params[:username])
        if user&.authenticate(login_params[:password])
            session[:user_id] = user.id
            render json: user, status: :created
          else
            render json: { error: "Invalid username or password" }, status: :unauthorized
        end
    end

    def destroy
        session.delete :user_id
        head :no_content
    end

    private

    def login_params
        params.permit(:username, :password)
    end

end
