require File.dirname(__FILE__) + '/../test_helper'

class CodeReviewSettingsControllerTest < ActionController::TestCase
  def setup
    @controller = CodeReviewSettingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_REFERER"] = '/'
    enabled_module = EnabledModule.new
    enabled_module.project_id = 1
    enabled_module.name = 'code_review'
    enabled_module.save

    User.current = nil
    roles = Role.find(:all)
    roles.each {|role|
      role.permissions << :view_code_review
      role.save
    }
  end

  def test_show
    @request.session[:user_id] = 1
    get :show, :id => 1
    assert_response :success

    @request.session[:user_id] = User.anonymous.id
    get :show, :id => 1
    assert_response 403
  end

  def test_update
    @request.session[:user_id] = User.anonymous.id
    get :update, :id => 1
    assert_response 403

    @request.session[:user_id] = 1
    setting = CodeReviewUserSetting.find_or_create(1)
    get :update, :id => 1, :setting => {:mail_notification => setting.mail_notification, :user_id => setting.user_id, :id => setting.id}
    assert_response :redirect
    project = Project.find(1)
    assert_redirected_to :action => 'show', :id => project
  end
end
