class NotificationsController < ApplicationController
  before_action :logged_in_user

  def index
    @notifications = current_user.passive_notifications.paginate(page: params[:page], :per_page => 12)
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
    aside_settings
  end
end
