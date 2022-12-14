# This file is a part of RedmineX UX Upgrade plugin
# for Redmine
#
# Copyright 2020-2022 RedmineX. All Rights Reserved.
# https://www.redmine-x.com
#
# Licensed under GPL v2 (http://www.gnu.org/licenses/gpl-2.0.html)
# Created by Ondřej Svejkovský

module RedmineXUxUpgrade
    module AttachmentsHelperPatch
      def self.included(receiver)
        receiver.class_eval do

          # *********************
          # * Redefined methods *
          # *********************

          # Redefined - line 38
          # CHANGE - Attachments order by date was reversed - newest our displayed first now
          def link_to_attachments(container, options = {})
            options.assert_valid_keys(:author, :thumbnails)
            attachments =
              if container.attachments.loaded?
                container.attachments.reverse_order
              else
                container.attachments.reverse_order.preload(:author).to_a
              end
            if attachments.any?
              options = {
                :editable => container.attachments_editable?,
                :deletable => container.attachments_deletable?,
                :author => true
              }.merge(options)
              render :partial => 'attachments/links',
                :locals => {
                  :container => container,
                  :attachments => attachments,
                  :options => options,
                  :thumbnails => (options[:thumbnails] && Setting.thumbnails_enabled?)
                }
            end
          end
        end
      end
    end
  end

  unless AttachmentsHelper.included_modules.include?(RedmineXUxUpgrade::AttachmentsHelperPatch)
    AttachmentsHelper.send(:include, RedmineXUxUpgrade::AttachmentsHelperPatch)
  end