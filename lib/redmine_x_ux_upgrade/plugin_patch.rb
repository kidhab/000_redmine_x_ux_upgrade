# This file is a part of RedmineX UX Upgrade plugin
# for Redmine
#
# Copyright 2020-2022 RedmineX. All Rights Reserved.
# https://www.redmine-x.com
#
# Licensed under GPL v2 (http://www.gnu.org/licenses/gpl-2.0.html)
# Created by Ondřej Svejkovský

module RedmineXUxUpgrade
  module PluginPatch
    module Plugin

      # *********************
      # * Redefined methods *
      # *********************

      # Redefined - line 337
      # Change - returns our custom projectino menu instead of standard project menu and
      #          top hamburger menu instead of standard top menu
      def menu(menu, item, url, options={})
        menu = :projectino_project_menu if menu == :project_menu
        menu = :top_menu_hamburger_plugins if menu == :top_menu
        Redmine::MenuManager.map(menu).push(item, url, options)
      end
    end

    def self.included(receiver)
      receiver.class_eval do
        prepend Plugin
        def menu(menu, item, url, options={})
          self.menu(menu, item, url, options={})
        end
      end
    end
  end
end
unless Redmine::Plugin.included_modules.include?(RedmineXUxUpgrade::PluginPatch)
  Redmine::Plugin.send(:include, RedmineXUxUpgrade::PluginPatch)
end
