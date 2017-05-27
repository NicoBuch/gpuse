class PublishedCodeSerializer < ActiveModel::Serializer
  attributes :code

  has_many :frames
end
