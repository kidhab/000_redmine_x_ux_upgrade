# This file is a part of RedmineX UX Upgrade plugin
# for Redmine
#
# Copyright 2020-2022 RedmineX. All Rights Reserved.
# https://www.redmine-x.com
#
# Licensed under GPL v2 (http://www.gnu.org/licenses/gpl-2.0.html)
# Created by Ondřej Svejkovský

module RedmineXUxUpgrade
  module MyHelperPatch
    def self.included(receiver)
      receiver.class_eval do

        # *********************
        # * Redefined methods *
        # *********************

        # Redefined - line 34
        # Change - adds collapse icon to every block to enable 'closing' of the blocks
        def render_block(block, user)
          content = render_block_content(block, user)
          if content.present?
            handle = content_tag('span', '', :class => 'icon-only icon-sort-handle sort-handle', :title => l(:button_move))
            close = link_to(l(:button_delete),
                            {:action => "remove_block", :block => block},
                            :remote => true, :method => 'post',
                            :class => "icon-only icon-close", :title => l(:button_delete))

            # new 'open/collapse' icon
            collapse =
              content_tag('span', '', :class => 'icon-collapse', :title => l(:my_open_close_icon_button), 'data-user': User.current.id,  onclick: "window.RXU.MyPage.myPageBlockToggle(this);" ) do
                content_tag('i', '', :class => 'fal fa fa-chevron-up')
              end

            content = content_tag('div', handle + close + collapse, :class => 'contextual') + content
            content_tag('div', content, :class => "mypage-box", :id => "block-#{block}")
          end
        end
      end
    end
  end
end
unless MyHelper.included_modules.include?(RedmineXUxUpgrade::MyHelperPatch)
    MyHelper.send(:include, RedmineXUxUpgrade::MyHelperPatch)
end