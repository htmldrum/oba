module V0
  class UsersController < BaseController
    def create
      ActiveRecord::Base.transaction do
        @resource = model_params['pin'].nil? ?
                      FactoryGirl.build(:user) :
                      FactoryGirl.build(:user, pin: model_params['pin'])
        @resource.addresses << FactoryGirl.build(:address, user: @resource)
        @resource.accounts << FactoryGirl.build(:account, user: @resource)
        @resource.save!
      end
      respond_to do |f|
        f.any do
          response.headers['location'] = send("v#{api_version}_#{model_name.underscore}_url", @resource)
          render({json: @resource,
                  serializer: each_sez,
                  status: :created}.merge!(render_options))
        end
      end
    end

    def model_params
      params
        .require(:user)
        .permit(:pin)
    end
  end
end
