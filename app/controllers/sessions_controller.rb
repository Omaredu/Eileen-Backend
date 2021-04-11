class SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email])&.authenticate(session_params[:password])

    if user
      payload = { user_id: user.id }
      token = JWT.encode payload, Rails.application.credentials.jwt_sign, 'HS256'

      render json: { token: token, errors: [] }
    else
      render json: { token: nil, errors: [ "Invalid email or password" ] }
    end
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end
