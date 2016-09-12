$HMAC_METHOD = 'HS256'.freeze
if Rails.env.prod?
  $HMAC_SECRET = ENV['ac02fd6e'].freeze
else
  $HMAC_SECRET = 'SANTA_ISNT_REAL?!??!!'.freeze
end
$JWT_EXPIRY = 20.days
$JWT_ISSUER = 'OneFill Inc'
$JWT_AUD = ['OBA','SUP','PUD','ADA']
