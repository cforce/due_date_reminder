module Reminder
  class ReminderViewHook < Redmine::Hook::ViewListener
    def view_layouts_base_body_bottom(context={})
      if context[:controller] && (context[:controller].is_a?(MyController))
        <<-SRC
        <script type='text/javascript'>
          $('#no_self_notified').parent().parent().append($('#reminder_notification'));
        </script>
        SRC
      end
    end

    def view_my_account(context={})
      <<-SRC
	  </fieldset>
	  <fieldset class="box" id="reminder_notification">
      <legend>
	    #{l(:reminder_title)}
	  </legend>
	  <div class="tabular">
	    <p>
        #{context[:form].text_field :reminder_notification, :required => true, :size => 10,
                                    :value => context[:user].reminder_notification}
        </p>
		<p>
        #{context[:form].check_box :reminder_author_notification,
                            :label => :field_reminder_author_user_notification}
        </p>
      </div>
	  </fieldset>
      SRC
    end
  end
end