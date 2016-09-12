module V0
  # BaseController: Base class for API v0 controllers
  class BaseController < GenericController
    include ErrorHandlable

    before_action :authenticate
    before_action :attach_resource, only: [:show, :update]

    protect_from_forgery with: :null_session
    serialization_scope :view_context

    def authenticate
      authenticate_or_request_with_http_token do |t, _|
        @user ||= User.authenticate(t)
      end
    end

    def cscope
      cs = super
      cs = cs.where(['updated_at >= ?', parse_time(params[:updated_since])]) if params[:updated_since]
      cs = cs.where(['created_at >= ?', parse_time(params[:created_since])]) if params[:created_since]
      cs
    end

    private

    def parse_time(s)
      Time.zone.parse(s)
    end
  end
end
