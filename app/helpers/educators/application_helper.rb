module Educators::ApplicationHelper

  def body_class
   "#{controller.controller_path.parameterize.gsub('-', '_')} #{controller.action_name}"
  end

  def bootstrap_class_for(flash_type)
    string_for(flash_type)[:class]
  end

  def string_for(flash_type)
    case flash_type.to_sym
    when :success, :notice
      { icon: 'check', class: 'alert-success' }
    when :error, :alert
      { icon: 'ban', class: 'alert-danger' }
    when :info
      { icon: 'info', class: 'alert-info' }
    else
      { icon: 'warning', class: 'alert-warning' }
    end
  end

end