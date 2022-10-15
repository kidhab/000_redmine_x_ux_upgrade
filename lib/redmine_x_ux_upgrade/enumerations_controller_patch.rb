# This file is a part of RedmineX UX Upgrade plugin
# for Redmine
#
# Copyright 2020-2022 RedmineX. All Rights Reserved.
# https://www.redmine-x.com
#
# Licensed under GPL v2 (http://www.gnu.org/licenses/gpl-2.0.html)
# Created by Ondřej Svejkovský

module RedmineXUxUpgrade
  module EnumerationsControllerPatch
    module InstanceMethods

      # *********************
      # * Redefined methods *
      # *********************

      # Redefined - line 110
      # position_name added to the enumeration params
      def enumeration_params
        # can't require enumeration on #new action
        cf_ids = @enumeration.available_custom_fields.map {|c| c.multiple? ? {c.id.to_s => []} : c.id.to_s}
        params.permit(:enumeration => [:name, :position_name, :active, :is_default, :position, :custom_field_values => cf_ids])[:enumeration]
      end
    end

    def self.included(receiver)
      receiver.class_eval do
        prepend InstanceMethods
        def enumeration_params
          self.enumeration_params
        end
      end
    end
  end
end
unless EnumerationsController.included_modules.include?(RedmineXUxUpgrade::EnumerationsControllerPatch)
  EnumerationsController.send(:include, RedmineXUxUpgrade::EnumerationsControllerPatch)
end
