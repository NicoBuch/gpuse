class Subscriber < ApplicationRecord
  validates :eth_address, presence: true
  validates :eth_address, uniqueness: true

  has_many :frames

  def generate_access_token
    payload = { subscriber_id: id }
    TokenManager::AuthToken.encode(payload)
  end

  def connect
    update(connected: true)
  end

  def disconnect
    update(connected: false)
  end
end
