# This file is a part of RedmineX UX Upgrade plugin
# for Redmine
#
# Copyright 2020-2022 RedmineX. All Rights Reserved.
# https://www.redmine-x.com
#
# Licensed under GPL v2 (http://www.gnu.org/licenses/gpl-2.0.html)
# Created by Ondřej Svejkovský

module RedmineXUxUpgrade
  module MyPagePatch
    def self.included(receiver)
      # increase limit of issues blocks on my page to 99
      new_core_blocks = receiver::CORE_BLOCKS.dup
      new_core_blocks['issuequery'][:max_occurs] = 99;

      receiver.class_eval do

        # ***********************
        # * Redefined constants *
        # ***********************

        # Redefined - line 26
        remove_const :CORE_BLOCKS
        const_set :CORE_BLOCKS, new_core_blocks.freeze
      end
    end
  end
end

unless Redmine::MyPage.included_modules.include?(RedmineXUxUpgrade::MyPagePatch)
  Redmine::MyPage.send(:include, RedmineXUxUpgrade::MyPagePatch)
end
