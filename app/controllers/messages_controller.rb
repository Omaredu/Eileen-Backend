class MessagesController < ApplicationController
  before_action :authenticate!

  def show
    render json: { messages: Current.user.conversation.messages }
  end

  def create
    ibm_request = request_tone message: message_params[:body]

    if ibm_request['document_tone']['tones'].empty?
      @message = Current.user.conversation.messages.create body: message_params[:body],
                                                         tone: :tentative
    else
      @message = Current.user.conversation.messages.create body: message_params[:body],
                                                          tone: ibm_request['document_tone']['tones'][0]['tone_id']
    end

    render json: { message: @message, response: get_response(message: message_params[:body]) }
  end

  private

  def get_response(message: "")
    session_client = Google::Cloud::Dialogflow.sessions
    session = session_client.session_path project: 'eileen-nvvx',
                                          session: Current.dialogflow_session

    query_input = { text: { text: message, language_code: 'en-US' } }
    query_response = session_client.detect_intent session: session,
                                                  query_input: query_input

    query_response.query_result.fulfillment_text
  end

  def request_tone(message: "")
    HTTParty.get "",
                 query: {
                   version: '2017-09-21',
                   sentences: false,
                   text: message
                 },
                 headers: {
                   'Authorization' => ''
                 }
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
