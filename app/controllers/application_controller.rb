class ApplicationController < ActionController::Base

	private

  def response_data(data, message, status, error:nil, disabled:false, update:false, external_rating: nil, params: {})
    result = Hash.new
    result[:data] = data
    result[:message] = message
    result[:status] = status
    result[:error] = error
    result[:disabled] = disabled
    result[:update] = update
    result[:external_rating] = external_rating
    render json: result, params: params, status: status
  end

end
