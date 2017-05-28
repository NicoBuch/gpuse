class FileProcessingChannel < ApplicationCable::Channel
  def subscribed
    current_subscriber.connect
    stream_from "web_notifications_#{current_subscriber.id}"
  end

  def ready
    send_new_frame
  end

  def complete(data)
    FrameUpdater.perform_async(data, current_subscriber.id)
  end

  def retry(data)
    current_subscriber.update(working: false)
    Frame.find(data['frame_id']).update(taken: false)
    FrameSender.perform_async(current_subscriber.id)
  end

  def unsubscribed
    current_subscriber.disconnect
    current_subscriber.update!(working: false)
  end

  private

  def send_new_frame
    FrameSender.perform_async(current_subscriber.id)
  end

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
