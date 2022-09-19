
Redmine::Plugin.register '000_redmine_x_ux_upgrade'.to_sym do
  name 'RedmineX UX Upgrade'
  author 'Ondřej Svejkovský'
  description 'RedmineX UX Upgrade'
  version '1.3.0' # for Redmine v5.0.0
  url 'www.redmine-x.com'

  settings(
    :default => {
      :show_spent_time_in_top_menu => false,
      :number_of_items_in_project_menu => 8,
      :remember_collapsed_issues_state => false
    },
    :partial => 'settings/redmine_x_ux_upgrade_settings'
  )
end

include RedmineXUxUpgrade::MenuHelper
register_menu_items

plugin_path = Redmine::Plugin.registered_plugins[:"000_redmine_x_ux_upgrade"].path
require "#{plugin_path}/lib/redmine_x_ux_upgrade"


# Copy projectino theme and to public folder
FileUtils.cp_r("#{plugin_path}/assets/themes", "#{Rails.root}/public")

# Set redmine theme to 'projectino'
if ActiveRecord::Base.connection.table_exists? 'settings'
  Setting.ui_theme = 'redminex_theme'
  # Write settings to db, when plugin is installed for the 1st time => required by change logo functionality
  if Setting.where(name: 'plugin_000_redmine_x_ux_upgrade').empty?
    Setting["plugin_000_redmine_x_ux_upgrade"] = {
      show_spent_time_in_top_menu: false,
      number_of_items_in_project_menu: 8,
      remember_collapsed_issues_state: false
    }
  end
end

RedmineApp::Application.routes.prepend do
  scope '/home' do
    resources :welcome
  end
  match '/', :to => 'my#page', :via => [:get]
  post '/settings/plugin/000_redmine_x_ux_upgrade/remove_logo', to: 'settings#delete_attachment', as: 'delete_attachment'
end

RedmineXUxUpgrade::UxUpgradeAttachments.copy_plugin_images_after_restart

