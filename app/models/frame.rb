class Frame < ApplicationRecord
  belongs_to :published_code, inverse_of: :frames
  belongs_to :subscriber

  # mount_uploader :file, FrameUploader
  mount_base64_uploader :file, FrameUploader

  scope :available, -> { where(completed: false, taken: false) }
end
