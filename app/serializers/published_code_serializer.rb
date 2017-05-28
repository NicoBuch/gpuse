class PublishedCodeSerializer < ActiveModel::Serializer
  attributes :code, :file

  def file
    return nil if object.file.nil?
    object.file.url
  end
end
