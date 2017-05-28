class FileProcessingChannel < ApplicationCable::Channel
  def subscribed
    current_subscriber.connect
    stream_from "web_notifications_#{current_subscriber.id}"
  end

  def ready
    send_new_frame
  end

  def complete(data)
    # frame = Frame.find(data['frame_id']).update(file: data['file'], completed: true,
    #                                              time_elapsed: data['elapsed_time'],
    #                                              weis_earned: data['weis_earned'])
    # current_subscriber.update(working: false)
    # send_new_frame
    FrameUpdater.perform_async(data, current_subscriber.id)
  end

  def unsubscribed
    current_subscriber.disconnect
    current_subscriber.update!(working: false)
  end

  private

  def send_new_frame
    # while Frame.available.any?
    #   frame = find_frame
    #   if frame.present?
    #     current_subscriber.update!(working: true)
    #     return ActionCable.server.broadcast(
    #       "web_notifications_#{current_subscriber.id}", url: frame.file.url, code: frame.published_code.code, frame_id: frame.id
    #     )
    #   end
    # end
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
