class NotificationObserver < ActiveRecord::Observer

  def after_create(notification)
    Notifier.deliver_event_notice(notification)
  end
end

