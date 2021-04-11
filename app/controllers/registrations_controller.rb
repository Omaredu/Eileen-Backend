class RegistrationsController < ApplicationController
  def create
    user = User.new(user_params)
    user.conversation = Conversation.new

    if user.save
      render json: { errors: [] }, status: :created
    else
      render json: { errors: user.errors.full_messages }
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end