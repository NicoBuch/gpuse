class FrameUpdater
  include Sidekiq::Worker

  def perform(data, subscriber_id)
    subscriber = Subscriber.find(subscriber_id)
    frame = Frame.find(data['frame_id']).update(file: data['file'], completed: true,
                                                 time_elapsed: data['elapsed_time'],
                                                 weis_earned: data['weis_earned'])
    subscriber.update(working: false)
    FrameSender.new.perform(subscriber.id)
  end
end
