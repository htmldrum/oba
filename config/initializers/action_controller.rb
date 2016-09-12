# Adds AuthenticationError
module ActionController
  class AuthenticationError < ActionControllerError
    def as_json(options = {})
      {message: message}
    end
  end
end

# Adds error handling
# https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/http_authentication.rb#L513
module ActionController
  module HttpAuthentication
    module Token
      def authentication_request(controller, realm)
        controller.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
        raise AuthenticationError.new("401 Unauthorized")
        # controller.__send__ :render, :json => "HTTP Token: Access denied.\n", :status => :unauthorized
      end
    end
  end
end
