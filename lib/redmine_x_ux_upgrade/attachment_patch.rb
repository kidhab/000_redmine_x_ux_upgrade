# This file is a part of RedmineX UX Upgrade plugin
# for Redmine
#
# Copyright 2020-2022 RedmineX. All Rights Reserved.
# https://www.redmine-x.com
#
# Licensed under GPL v2 (http://www.gnu.org/licenses/gpl-2.0.html)
# Created by Ondřej Svejkovský

module RedmineXUxUpgrade
  module AttachmentPatch
    module InstanceMethods

      # *********************
      # * Redefined methods *
      # *********************

      # Redefined - line 201
      def visible?(user=User.current)
        if container_id && container.try(:name) != "plugin_000_redmine_x_ux_upgrade"
          container && container.attachments_visible?(user)
        elsif container.try(:name) == "plugin_000_redmine_x_ux_upgrade"
          true
        else
          author == user
        end
      end
    end

    def self.included(receiver)
      receiver.class_eval do
        prepend InstanceMethods
        def visible?(user=User.current)
          self.visible?(user=User.current)
        end
      end
    end
  end
end
unless Attachment.included_modules.include?(RedmineXUxUpgrade::AttachmentPatch)
  Attachment.send(:include, RedmineXUxUpgrade::AttachmentPatch)
end
