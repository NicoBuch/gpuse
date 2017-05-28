class PublishersController < ApplicationController

  skip_before_action :current_user, :authenticate_request, only: [:sign_in, :sign_up]

  def sign_in
    if valid_subscriber?
      access_token = subscriber.generate_access_token
      render json: { access_token: access_token }, status: :ok
    else
      render json: { error: 'Invalid Ethereum Address' }, status: :unauthorized
    end
  end

  def sign_up
    return render_eth_address_already_taken if subscriber.present?
    u = Subscriber.create(eth_address: params[:eth_address])
    return render json: { errors: u.errors.full_messages }, status: :bad_request unless u.valid?
    render json: { access_token: u.generate_access_token }, status: :ok
  end

  def completed_frame
    frame = Frame.find(params[:frame_id]).update(file: params[:file], completed: true,
                                                 elapsed_time: params[:elapsed_time],
                                                 weis_earned: params[:weis_earned])
    current_user.update(working: false)
    send_new_frame
    head :ok
  end

  private

  def send_new_frame
    while Frame.available.any?
      frame = find_frame
      if frame.present?
        current_user.update!(working: true)
        return ActionCable.server.broadcast(
          "web_notifications_#{current_user.id}", url: frame.file.url, code: frame.published_code.code, frame_id: frame.id
        )
      end
    end
  end

  def valid_subscriber?
    return false if params[:eth_address].blank?
    subscriber.present?
  end

  def render_eth_address_already_taken
    render json: { error: 'Ethereum address already taken' }, status: :bad_request
  end

  def subscriber
    Subscriber.find_by_username(params[:eth_address])
  end

  def current_user
    return nil unless decoded_auth_token.present?
    @current_user ||= Subscriber.find_by_id(decoded_auth_token[:subscriber_id])
  end

  def find_frame
    Frame.transaction do
      f = Frame.available.first
      f.lock!
      f.update!(taken: true, subscriber: current_user)
      f
    end
  rescue
    nil
  end
end