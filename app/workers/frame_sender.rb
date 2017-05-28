class FrameSender
  include Sidekiq::Worker

  def perform(subscriber_id)
    subscriber = Subscriber.find(subscriber_id)
    while Frame.available.any?
      frame = find_frame(subscriber)
      if frame.present?
        subscriber.update!(working: true)
        return ActionCable.server.broadcast(
          "web_notifications_#{subscriber.id}", url: frame.file.url, code: frame.published_code.code, frame_id: frame.id
        )
      end
    end
  end

  private

  def find_frame(subscriber)
    Frame.transaction do
      f = Frame.available.first
      f.lock!
      f.update!(taken: true, subscriber: subscriber)
      f
    end
  rescue
    nil
  end
end
