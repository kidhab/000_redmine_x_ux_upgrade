# This file is a part of RedmineX UX Upgrade plugin
# for Redmine
#
# Copyright 2020-2022 RedmineX. All Rights Reserved.
# https://www.redmine-x.com
#
# Licensed under GPL v2 (http://www.gnu.org/licenses/gpl-2.0.html)
# Created by Ondřej Svejkovský

module RedmineXUxUpgrade
  module EnumerationPatch
    module InstanceMethods

      # ***************
      # * New methods *
      # ***************

      def priority_options
        options = []
        (1..13).each do |i|
          options << [i,"priority-#{i}"]
        end
        options
      end
    end

    def self.included(receiver)
      receiver.class_eval do
        prepend InstanceMethods
        def priority_options
          self.priority_options
        end
      end
    end
  end
end
unless Enumeration.included_modules.include?(RedmineXUxUpgrade::EnumerationPatch)
  Enumeration.send(:include, RedmineXUxUpgrade::EnumerationPatch)
end
