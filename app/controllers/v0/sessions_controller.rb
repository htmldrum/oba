module V0
  class SessionsController < BaseController

    skip_before_action: :authenticate, :only => [:create]

    def create
      @resource.generate_auth_token!
      @resource.save!
      respond_to do |f|
        f.any do
          render({json: @resource,
                  serializer: each_sez,
                  status: :ok
                 }.merge!(render_options))
        end
      end
    end

    private

    def model_params
      params
        .require(:pin)
    end
    def attach_resource
      @resource ||= User.find_by!(pin: model_params)
    end
  end
end
