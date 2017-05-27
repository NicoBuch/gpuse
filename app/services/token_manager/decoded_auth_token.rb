module TokenManager
  class DecodedAuthToken < HashWithIndifferentAccess
    def expired?
      false
    end
  end
end
