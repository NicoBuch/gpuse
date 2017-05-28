class JobOriginatorChannel < ApplicationCable::Channel

  def subscribed
    stream_from "job_originator_#{current_subscriber.address}"
  end

end
