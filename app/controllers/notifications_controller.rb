class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.unread.order(created_at:'DESC')
  end

  def show
    @notification = Notification.find(params[:id])
    @notification.update_attributes(read_at:Time.now)
    redirect_to dashboard_users_path
  end


end
