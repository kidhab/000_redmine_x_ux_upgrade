# This file is a part of RedmineX UX Upgrade plugin
# for Redmine
#
# Copyright 2020-2022 RedmineX. All Rights Reserved.
# https://www.redmine-x.com
#
# Licensed under GPL v2 (http://www.gnu.org/licenses/gpl-2.0.html)
# Created by Ondřej Svejkovský

base_path = File.dirname(__FILE__)

require "#{base_path}/redmine_x_ux_upgrade/view_projects_hook"
require "#{base_path}/redmine_x_ux_upgrade/enumeration_patch"
require "#{base_path}/redmine_x_ux_upgrade/menu_controller_patch"
require "#{base_path}/redmine_x_ux_upgrade/menu_helper_patch"
require "#{base_path}/redmine_x_ux_upgrade/menu_node_patch"
require "#{base_path}/redmine_x_ux_upgrade/plugin_patch"
require "#{base_path}/redmine_x_ux_upgrade/issue_priority_patch"
require "#{base_path}/redmine_x_ux_upgrade/enumerations_controller_patch"
require "#{base_path}/redmine_x_ux_upgrade/settings_controller_patch"
require "#{base_path}/redmine_x_ux_upgrade/setting_patch"
require "#{base_path}/redmine_x_ux_upgrade/attachment_patch"
require "#{base_path}/redmine_x_ux_upgrade/application_helper_patch"
require "#{base_path}/redmine_x_ux_upgrade/issues_helper_patch"
require "#{base_path}/redmine_x_ux_upgrade/my_page_patch"
require "#{base_path}/redmine_x_ux_upgrade/my_helper_patch"
require "#{base_path}/redmine_x_ux_upgrade/attachments_helper_patch"
require "#{base_path}/redmine_x_ux_upgrade/queries_helper_patch"

module RedmineXUxUpgrade
  DEFAULT_SETTINGS_HISTORY = [
    { version: 131, settings: [:redirect_to_my_page, :show_home_page_in_top_menu] }
  ]

  def self.settings() Setting[:plugin_000_redmine_x_ux_upgrade].blank? ? {} : Setting[:plugin_000_redmine_x_ux_upgrade]  end

  def self.logo_url
    default_logo = ActionController::Base.helpers.asset_path("#{Redmine::Utils::relative_url_root}/themes/redminex_theme/images/logo.svg", :plugin => '000_redmine_x_ux_upgrade')
    settings = Setting.find_by(name: 'plugin_000_redmine_x_ux_upgrade')
    return default_logo unless settings

    logo = settings.attachments.where(description: 'logo')&.last
    redmine_x_ux_theme_path = File.join(Rails.root, 'public', 'themes', 'redminex_theme', 'images')
    path_to_logo = "#{redmine_x_ux_theme_path}/#{logo.disk_filename}" if logo

    if path_to_logo && File.exist?(path_to_logo)
      return ActionController::Base.helpers.asset_path("#{Redmine::Utils::relative_url_root}/themes/redminex_theme/images/#{logo.disk_filename}", :plugin => '000_redmine_x_ux_upgrade')
    end

    #default logo if not set
    default_logo
  end

  # list of supported plugins (aka styles that are not being loaded) that go to %w[]: redmine_agile redmine_banner redmine_checklists redmine_contacts redmine_contacts_invoices redmine_contacts_helpdesk redmine_crm redmine_dashboard redmine_dmsf redmine_issue_dynamic_edit redmine_issue_evm redmine_issue_templates redmine_mentions redmine_messenger redmine_resources redmine_risks that_meeting
  def self.supported_plugin_list
    %w[].freeze
  end

  # list of forbidden redmine css files that go to %w[]:application context_menu context_menu_rtl jquery/jquery-ui-1.11.0 jstoolbar responsive rtl scm tribute-3.7.3
  def self.redmine_css_to_overwrite
    %w[].freeze
  end

  # Sets redminex_theme to Redmine settings
  # @return [nil] - nothing is returned
  def self.set_redmine_x_theme
    Setting.ui_theme = 'redminex_theme' if ActiveRecord::Base.connection.table_exists? 'settings'
  end

  # Writes default settings, which were not present in the previous version of the plugin into DB
  # @return [nil] - nothing is returned
  def self.save_default_settings
    return unless ActiveRecord::Base.connection.table_exists? 'settings'
    return if Setting.where(name: 'plugin_000_redmine_x_ux_upgrade').empty?

    previous_plugin_version = Setting.plugin_000_redmine_x_ux_upgrade[:version].to_i
    current_default_settings = Redmine::Plugin.find('000_redmine_x_ux_upgrade').settings[:default]
    current_settings = Setting.plugin_000_redmine_x_ux_upgrade

    settings_to_write = []
    DEFAULT_SETTINGS_HISTORY.each do |set|
      next if set[:version] <= previous_plugin_version
      settings_to_write += set[:settings]
    end

    settings_to_write.each do |setting|
      next if current_default_settings[setting] == false
      current_settings[setting] = current_default_settings[setting]
    end

    current_settings[:version] = current_default_settings[:version]
    Setting.plugin_000_redmine_x_ux_upgrade = current_settings
  end
end
