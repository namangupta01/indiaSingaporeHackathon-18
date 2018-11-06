class ApplicationController < ActionController::Base

	private

  def response_data(data, message, status, error:nil)
    result = Hash.new
    result[:data] = data
    result[:message] = message
    result[:status] = status
    result[:error] = error
    render json: result, status: status
  end

end
