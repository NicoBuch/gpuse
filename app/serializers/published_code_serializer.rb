class PublishedCodeSerializer < ActiveModel::Serializer
  attributes :file

  def file
    return nil if object.file.nil?
    object.file.url
  end

  has_many :frames
end
