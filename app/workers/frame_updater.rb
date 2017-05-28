class FrameUpdater
  include Sidekiq::Worker

  def perform(data, subscriber_id)
    subscriber = Subscriber.find(subscriber_id)
    frame = Frame.find(data['frame_id']).update(file: data['file'], completed: true,
                                                 time_elapsed: data['elapsed_time'],
                                                 weis_earned: data['weis_earned'])
    subscriber.update(working: false)
    FrameSender.new.perform(subscriber.id)

    # TODO get file path to video
    result_path = ""
    ActionCable.server.broadcast(
      "job_originator_#{frame.publish_code.address}", result_path: result_path, address: subscriber.eth_address
    )
  end
end
