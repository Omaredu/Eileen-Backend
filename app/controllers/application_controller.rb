class ApplicationController < ActionController::API
  def authenticate!
    token = request.headers['Authorization'].split(' ').last
    decoded_payload = JWT.decode(token, Rails.application.credentials.jwt_sign, true, { algorithm: 'HS256' })[0]

    user = User.find_by(id: decoded_payload['user_id'])

    Current.user = user
    Current.dialogflow_session = (0...8).map { (65 + rand(26)).chr }.join

    unless Current.user
      render json: { errors: [ "Invalid user" ] }, status: :forbidden
    end

  rescue
    render json: { errors: [ "Invalid authorization token" ] }, status: :forbidden
  end
end
