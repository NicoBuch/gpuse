class FrameSerializer < ActiveModel::Serializer
  attributes :index, :time_elapsed, :weis_earned, :file, :subscriber_address

  def file
    return nil if object.file.nil?
    object.file.url
  end

  def subscriber_address
    object.subscriber.eth_address
  end
end
