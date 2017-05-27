class PublishersController < ApplicationController

  skip_before_action :current_user, :authenticate_request, only: [:sign_in, :sign_up]

  def sign_in
    if valid_publisher?
      access_token = publisher.generate_access_token
      render json: { access_token: access_token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def sign_up
    return render_username_already_taken if publisher.present?
    u = Publisher.create(username: params[:username], password: params[:password], eth_address: params[:eth_address])
    return render json: { errors: u.errors.full_messages }, status: :bad_request unless u.valid?
    render json: { access_token: u.generate_access_token }, status: :ok
  end

  def update_eth_address
    current_user.update(eth_address: params[:eth_address])
    head :ok
  end

  def publish
    publication = PublishedCode.create(publish_params.merge(publisher: current_user))
    return render json: { errors: publication.errors.full_messages }, status: :bad_request unless publication.valid?
    Subscriber.where(connected: true, working: false).each do |subscriber|
      frame = publication.frames.avaliable.first
      frame.update!(taken: true, subscriber: subscriber)
      subscriber.update!(working: true)
      FileProcessingChannel.broadcast_to subscriber, url: frame.file.url, code: frame.published_code.code, frame_id: frame.id
    end
    render json: { published_code_id: publication.id }, status: :created
  end

  def completed_publication
    publication = PublishedCode.find_by_id(params[:published_code_id])
    return render json: { error: 'Inexistent Publication' }, status: :bad_request if publication.nil?
    if publication.frames.where(completed: false).any?
      return render json: { message: 'Publication not completed yet' }, status: :no_content
    end
    render json: publication, status: :ok
  end

  private

  def valid_publisher?
    return false if params[:username].blank? || params[:password].blank?
    publisher.present? && publisher.valid_password?(params[:password])
  end

  def render_username_already_taken
    render json: { error: 'Username already taken' }, status: :bad_request
  end

  def publisher
    Publisher.find_by_username(params[:username])
  end

  def current_user
    return nil unless decoded_auth_token.present?
    @current_user ||= Publisher.find_by_id(decoded_auth_token[:publisher_id])
  end

  def publish_params
    params.require(:code)
    params.require(:frames)
    params.permit(:code, frames_attributes: [:index, :file])
  end
end
