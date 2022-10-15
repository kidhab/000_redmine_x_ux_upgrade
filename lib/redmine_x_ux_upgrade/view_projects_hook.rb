# This file is a part of RedmineX UX Upgrade plugin
# for Redmine
#
# Copyright 2020-2022 RedmineX. All Rights Reserved.
# https://www.redmine-x.com
#
# Licensed under GPL v2 (http://www.gnu.org/licenses/gpl-2.0.html)
# Created by Ondřej Svejkovský

module RedmineXUxUpgrade
  class ViewProjectsHook < Redmine::Hook::ViewListener
    include RedmineXUxUpgrade::ProjectAggregatorHelper

    # Show project aggregator box on the right side of project overview page
    #
    # @param context [Hash] context passed by redmine, when hook is called
    def view_projects_show_right(context = {})
      completion = project_completion(context[:hook_caller])
      progress = project_progress(context[:hook_caller])

      context[:hook_caller].send(
        :render,
        partial: 'project_aggregator',
        locals: { completion: completion, progress: progress }
      )
    end
  end
end
