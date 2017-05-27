class FrameSerializer < ActiveModel::Serializer
  attributes :index, :time_elapsed

  def file
    return nil if object.file.nil?
    object.file.url
  end
end
