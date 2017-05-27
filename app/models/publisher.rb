class Publisher < ApplicationRecord
  validates :username, :password, presence: true
  validates :username, uniqueness: true

  has_may :published_codes

  before_save :encrypt_password, if: :password_changed?

  def generate_access_token
    payload = { publisher_id: id }
    TokenManager::AuthToken.encode(payload)
  end

  def valid_password?(password)
    decrypted_password == password
  end

  private

  def decrypted_password
    DataEncryption.decrypt(password)
  end

  def encrypt_password
    self.password = DataEncryption.encrypt(password)
  end
end
