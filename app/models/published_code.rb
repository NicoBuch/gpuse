class PublishedCode < ApplicationRecord
  belongs_to :publisher

  has_many :frames, inverse_of: :published_code

  mount_uploader :file, PublicationUploader

  accepts_nested_attributes_for :frames
end
