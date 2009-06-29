require File.dirname(__FILE__) + '/../test_helper'

class CodeReviewUserSettingTest < Test::Unit::TestCase
  fixtures :code_review_user_settings

  # Replace this with your real tests.
  def test_find_or_create
    setting = CodeReviewUserSetting.find_or_create(2)

    assert_equal(2, setting.user_id)
    assert_equal(2, setting.mail_notification)

    assert !CodeReviewUserSetting.find_by_user_id(:first, 9)
    setting = CodeReviewUserSetting.find_or_create(9)
    assert_equal(9, setting.user_id)
    assert_equal(CodeReviewUserSetting::NOTIFICATION_INVOLVED_IN, setting.mail_notification)
    setting.destroy
  end

  def test_mail_notification_none?
    setting = CodeReviewUserSetting.find_by_user_id(3)
    assert setting.mail_notification_none?
    assert !setting.mail_notification_involved_in?
    assert !setting.mail_notification_all?
  end

  def test_mail_notification_involved_in?
    setting = CodeReviewUserSetting.find_by_user_id(1)
    assert !setting.mail_notification_none?
    assert setting.mail_notification_involved_in?
    assert !setting.mail_notification_all?
  end

  def test_mail_notification_all?
    setting = CodeReviewUserSetting.find_by_user_id(2)
    assert !setting.mail_notification_none?
    assert !setting.mail_notification_involved_in?
    assert setting.mail_notification_all?
  end
end
