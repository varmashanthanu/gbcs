class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :recipient, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> {where(read_at:nil)}

  after_commit :notify, on: :create

  def notify
    NotificationRelayJob.perform_later(self)
  end

end
