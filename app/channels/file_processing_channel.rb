class FileProcessingChannel < ApplicationCable::Channel
  def subscribed
    current_subscriber.connect
    while Frame.avaliable.any?
      frame = find_frame
      if frame.present?
        current_subscriber.update!(working: true)
        return self.class.broadcast_to(
          current_subscriber, url: frame.file.url, code: frame.published_code.code, frame_id: frame.id
        )
      end
    end
  end

  def unsubscribed
    current_subscriber.disconnect
  end

  private

  def find_frame
    Frame.transaction do
      f = Frame.avaliable.first
      f.lock!
      f.update!(taken: true, subscriber: current_subscriber)
      f
    end
  rescue
    nil
  end
end
