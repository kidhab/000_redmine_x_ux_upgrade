module RedmineXUxUpgrade
  module MenuControllerPatch
    module InstanceMethods

      # *********************
      # * Redefined methods *
      # *********************

      # Redefined - line 60
      # Change - replaces original project menu, with our custom projectino menu
      def current_menu(project)
        if project && !project.new_record?
          :projectino_project_menu
        elsif self.class.main_menu
          :application_menu
        end
      end
    end

    def self.included(receiver)
      receiver.class_eval do
        prepend InstanceMethods
        def current_menu(project)
          self.current_menu(project)
        end
      end
    end
  end
end
unless Redmine::MenuManager::MenuController.included_modules.include?(RedmineXUxUpgrade::MenuControllerPatch)
  Redmine::MenuManager::MenuController.send(:include, RedmineXUxUpgrade::MenuControllerPatch)
end