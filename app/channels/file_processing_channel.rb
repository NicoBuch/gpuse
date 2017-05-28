class FileProcessingChannel < ApplicationCable::Channel
  def subscribed
    current_subscriber.connect
    stream_from "web_notifications_#{current_subscriber.id}"
  end

  def ready
    while Frame.available.any?
      frame = find_frame
      if frame.present?
        current_subscriber.update!(working: true)
        return ActionCable.server.broadcast(
          "web_notifications_#{current_subscriber.id}", url: frame.file.url, code: frame.published_code.code, frame_id: frame.id
        )
      end
    end
  end

  def unsubscribed
    current_subscriber.disconnect
    current_subscriber.update!(working: false)
  end

  private

  def find_frame
    Frame.transaction do
      f = Frame.available.first
      f.lock!
      f.update!(taken: true, subscriber: current_subscriber)
      f
    end
  rescue
    nil
  end
end
