# User: API users.
class User < ActiveRecord::Base
  def self.authenticate(t)
    find_by(auth_token: t)
  end
  private
  def generate_auth_token!
    self.auth_token = JWT.encode(token_body,
                                 $HMAC_SECRET,
                                 $HMAC_METHOD)
  end
  def token_body
    {
      :data => { id: id },
      :exp => expiry,
      :iss => issuer,
      :aud => audience,
      :iat => issued_at
    }
  end
  def expiry
    (issued_at + $JWT_EXPIRY).to_i
  end
  def issuer
    $JWT_ISSUER
  end
  def audience
    $JWT_AUD
  end
  def issued_at
    @issued_at =|| Time.now.to_i
  end
end
