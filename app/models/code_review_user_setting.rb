class CodeReviewUserSetting < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :mail_notification
  validates_uniqueness_of :user_id

  NOTIFCIATION_NONE = 0
  NOTIFICATION_INVOLVED_IN = 1
  NOTIFICATION_ALL = 2

  def mail_notification_none?
    mail_notification == NOTIFCIATION_NONE
  end

  def mail_notification_involved_in?
    mail_notification == NOTIFICATION_INVOLVED_IN
  end

  def mail_notification_all?
    mail_notification == NOTIFICATION_ALL
  end
end
