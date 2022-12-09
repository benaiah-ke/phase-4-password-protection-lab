class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

    def create
        return head :unprocessable_entity unless user_params[:password] == user_params[:password_confirmation]
        user = User.create(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    def show
        return render json: {error: "Not authorized"}, status: :unauthorized unless session.include? :user_id
        user = User.find(session[:user_id])
        render json: user
    end
    
    private
    
    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def render_unprocessable_entity
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end

end
