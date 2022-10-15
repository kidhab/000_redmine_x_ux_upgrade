# This file is a part of RedmineX UX Upgrade plugin
# for Redmine
#
# Copyright 2020-2022 RedmineX. All Rights Reserved.
# https://www.redmine-x.com
#
# Licensed under GPL v2 (http://www.gnu.org/licenses/gpl-2.0.html)
# Created by Ondřej Svejkovský

require_dependency 'issue_priority'
module RedmineXUxUpgrade
  module IssuePriorityPatch
    module InstanceMethods

      # *********************
      # * Redefined methods *
      # *********************

      # Redefined - line 45
      def css_classes
        position_name
      end
    end

    def self.included(receiver)
      receiver.class_eval do
        prepend InstanceMethods
        def css_classes
          self.css_classes
        end

        # *********************
        # * Redefined methods *
        # *********************

        # Redefined - line 72
        def self.compute_position_names
          # do nothing
          false
        end
      end
    end
  end
end
unless IssuePriority.included_modules.include?(RedmineXUxUpgrade::IssuePriorityPatch)
  IssuePriority.send(:include, RedmineXUxUpgrade::IssuePriorityPatch)
end
