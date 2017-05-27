class Frame < ApplicationRecord
  belongs_to :published_code, inverse_of: :frames

  mount_uploader :file, FrameUploader
end
