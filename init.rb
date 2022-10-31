# This file is a part of RedmineX UX Upgrade plugin
# for Redmine
#
# Copyright 2020-2022 RedmineX. All Rights Reserved.
# https://www.redmine-x.com
#
# Licensed under GPL v2 (http://www.gnu.org/licenses/gpl-2.0.html)
# Created by Ondřej Svejkovský

Redmine::Plugin.register :'000_redmine_x_ux_upgrade' do
  name 'RedmineX UX Upgrade'
  author 'Ondřej Svejkovský'
  description 'RedmineX UX Upgrade'
  version '1.3.5' # for Redmine v5.0.2
  url 'www.redmine-x.com'

  settings(
    default: {
      number_of_items_in_project_menu: 8,
      redirect_to_my_page: true,
      remember_collapsed_issues_state: false,
      show_home_page_in_top_menu: false,
      show_spent_time_in_top_menu: false,
      version: 135 # for Redmine v5.0.2
    },
    partial: 'settings/redmine_x_ux_upgrade_settings'
  )
end

include RedmineXUxUpgrade::MenuHelper
register_menu_items

plugin_path = Redmine::Plugin.registered_plugins[:'000_redmine_x_ux_upgrade'].path
require "#{plugin_path}/lib/redmine_x_ux_upgrade"

# Copy projectino theme and to public folder
FileUtils.cp_r("#{plugin_path}/assets/themes", "#{Rails.root}/public")

# Set redmine theme to 'redminex_theme'
RedmineXUxUpgrade.set_redmine_x_theme

# Save additional default settings if this is upgrade of older version # for Redmine v5.0.2
RedmineXUxUpgrade.save_default_settings

RedmineApp::Application.routes.prepend do
  scope '/home' do
    resources :welcome
  end
  match '/', :to => 'redmine_x_ux_upgrade#root', :via => [:get]
  post '/settings/plugin/000_redmine_x_ux_upgrade/remove_logo', to: 'settings#delete_attachment', as: 'delete_attachment'
end

RedmineXUxUpgrade::UxUpgradeAttachments.copy_plugin_images_after_restart

