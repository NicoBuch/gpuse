class FrameSerializer < ActiveModel::Serializer
  attributes :time_elapsed, :satoshis, :subscriber_address

  def subscriber_address
    object.subscriber.eth_address
  end

  def satoshis
    object.weis_earned
  end
end
