require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  context "user" do

    setup do
      @user = create(:user, :reminder_notification => '1,3,5', :reminder_author_notification => false)
    end


    should "include reminder notification to user safe attributes" do
      assert_contains @user.safe_attribute_names, 'reminder_notification'
    end

    should "include reminder author notification to user safe attributes" do
      assert_contains @user.safe_attribute_names, 'reminder_author_notification'
    end

    context "validation of reminder notification" do

      should "not be valid" do
        assert !(User.valid_reminder_notification? "test")
      end

      should "be valid" do
        assert User.valid_reminder_notification? "1,2,33, 2,1  , 23"
      end

      should "be valid if empty" do
        assert User.valid_reminder_notification? "    "
      end

    end

    context "reminder settings" do

      should "return notification setting explicitly defined for user" do
        assert_equal '1,3,5', @user.reminder_notification
      end

      should "return author notification setting explicitly defined for user" do
        assert_equal false, @user.reminder_author_notification?
      end

      should "return empty settings" do
        @user.update_attributes(:reminder_notification => "   ")
        assert_equal [], @user.reminder_notification_array
      end

      should "convert settings to integer array" do
        assert_equal [1, 3, 5], @user.reminder_notification_array
      end

      should "return default notification settings for user" do
        @user.update_attributes(:reminder_notification => nil)
        Setting.plugin_due_date_reminder = {'reminder_notification' => '1,2,3,4,5'}
        assert_equal '1,2,3,4,5', @user.reminder_notification
      end

      should "return default author notification settings for user" do
        @user.update_attributes(:reminder_author_notification => nil)
        Setting.plugin_due_date_reminder = {'reminder_author_notification' => false}
        assert_equal false, @user.reminder_author_notification
      end

    end

  end
end
