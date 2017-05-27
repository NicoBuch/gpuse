class FrameSerializer < ActiveModel::Serializer
  attributes :index

  def file
    return nil if object.file.nil?
    object.file.url
  end
end
