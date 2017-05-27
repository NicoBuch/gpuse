class DataEncryption
  def self.encryptor
    ActiveSupport::MessageEncryptor.new(Rails.application.secrets.encryption_salt)
  end

  def self.encrypt(data)
    encryptor.encrypt_and_sign(data)
  end

  def self.decrypt(encrypted_data)
    encryptor.decrypt_and_verify(encrypted_data)
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    Rails.logger.error('Invalid salt')
  end
end
