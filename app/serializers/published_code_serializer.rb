class PublishedCodeSerializer < ActiveModel::Serializer
  attributes :code, :url

  def url
    Rails.root.joins("out_#{publication.id}.mp4")
  end
end
