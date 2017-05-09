require_dependency 'maintenance_mode_hooks'
require_dependency 'maintenance_mode'

Rails.logger.info 'Starting Maintenance Mode plugin for Redmine'


Redmine::Plugin.register :redmine_maintenance_mode do
  name 'Redmine Maintenance Mode'
  author 'Tobias Fischer'
  description 'This is a plugin to schedule and announce maintenance downtimes as well as disable user access to redmine during maintenance times.'
  version '2.0.1'
  url 'https://github.com/tofi86/redmine_maintenance_mode'
  author_url 'https://github.com/tofi86'
  
  requires_redmine :version_or_higher => '2.4.0'
  requires_redmine_plugin :redmine_base_deface, :version_or_higher => '0.0.1'
  
  settings :default => {
    'maintenance_active' => false,
    'maintenance_message' => '',
    'maintenance_schedule' => false,
    'schedule_message' => '',
    'schedule_start' => '2015-02-07 14:00',
    'schedule_end' => '2015-02-07 15:00'
  }, :partial => 'redmine_maintenance_mode_settings'
end


# Patches to the Redmine core.
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

if Rails::VERSION::MAJOR >= 3
  ActionDispatch::Callbacks.to_prepare do
    require_dependency 'application_controller'
    ApplicationController.send(:include, MaintenanceMode)
  end
else
  Dispatcher.to_prepare do
    require_dependency 'application_controller'
    ApplicationController.send(:include, MaintenanceMode)
  end
end
