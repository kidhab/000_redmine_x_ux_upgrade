# This file is a part of RedmineX UX Upgrade plugin
# for Redmine
#
# Copyright 2020-2022 RedmineX. All Rights Reserved.
# https://www.redmine-x.com
#
# Licensed under GPL v2 (http://www.gnu.org/licenses/gpl-2.0.html)
# Created by Ondřej Svejkovský

class RedmineXUxUpgradeController < ApplicationController
  # Redirects root to My Page or Home Page
  def root
    if Setting.plugin_000_redmine_x_ux_upgrade[:redirect_to_my_page]
      redirect_to controller: 'my', action: 'page'
    else
      redirect_to controller: 'welcome', action: 'index'
    end
  end

end