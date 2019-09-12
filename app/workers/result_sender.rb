class ResultSender
  include Sidekiq::Worker

  def perform(address)
    subscriber = Subscriber.find(subscriber_id)
    while Frame.available.any?
      frame = find_frame(subscriber)
      if frame.present?
        subscriber.update!(working: true)
        return ActionCable.server.broadcast(
          "web_notifications_#{subscriber.id}", {
            url: frame.file.url,
            code: frame.published_code.code,
            frame_id: frame.id,
            published_code_id: frame.published_code.id
          }
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
