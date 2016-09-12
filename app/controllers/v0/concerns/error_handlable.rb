# Rescue common error and return JSON format response
# TODO: Remove excessive function calls
# TODO: Remove json rendering - is up to requester to decide what
#       format they want
module ErrorHandlable
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActionController::ParameterMissing, with: :params_missing
    rescue_from ActionController::AuthenticationError, with: :authentication_error
  end

  def error!(message, details, status = 400)
    render json: {
      error: message,
      details: details
    }, status: status
  end

  private

  def record_invalid(exception)
    error!('Invalid record.', exception.record.errors.as_json, 400)
  end

  def record_not_found(exception)
    error!(exception.message, {}, 404)
  end

  def params_missing(exception)
    error!(exception.message, exception.as_json, 400)
  end

  def authentication_error(exception)
    error!(exception.message, exception.as_json, 401)
  end
end
