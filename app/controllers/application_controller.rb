class ApplicationController < ActionController::Base
  class NotAuthenticatedError < StandardError; end
  class AuthenticationTimeoutError < StandardError; end

  protect_from_forgery with: :null_session

  before_action :current_user, :authenticate_request, :set_locale, except: [:health, :index]

  rescue_from 'NotAuthenticatedError' do
    render json: { error: 'Not Authorized' }, status: :unauthorized
  end

  rescue_from 'AuthenticationTimeoutError' do
    render json: { error: 'Auth token is expired' }, status: 419
  end

  rescue_from ActionController::ParameterMissing, with: :render_nothing_bad_req

  rescue_from ActiveRecord::RecordNotFound, with: :render_nothing_bad_req

  def health
    head :ok
  end

  def set_locale
    I18n.locale = I18n.default_locale
  end

  def default_url_options(_options = {})
    { locale: I18n.locale }
  end

  def valid_locale?(locale)
    (locale == 'en') || (locale == 'es')
  end

  def default_serializer_options
    { root: false }
  end

  def current_location
    @current_location ||= [params[:lat], params[:lng]]
  end

  def index
  end

  private

  def authenticate_request
    raise AuthenticationTimeoutError if auth_token_expired?
    raise NotAuthenticatedError unless current_user.present?
  end

  def decoded_auth_token
    @decoded_auth_token ||= TokenManager::AuthToken.decode(http_auth_header_content)
  end

  def auth_token_expired?
    decoded_auth_token && decoded_auth_token.expired?
  end

  def http_auth_header_content
    return @http_auth_header_content if defined? @http_auth_header_content
    @http_auth_header_content = begin
      if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
    end
  end

  def render_nothing_bad_req
    render nothing: true, status: :bad_request
  end

  def render_errors(errors)
    render json: { errors: errors }, status: :bad_request
  end
end
