module RedmineXUxUpgrade
  module MenuNodePatch
    module InstanceMethods

      # *********************
      # * Redefined methods *
      # *********************

      # Redefined - line 399
      # Replaces method originla remove!, which removes items only from first level -
      # however in UX Upgrade we have also submenus and the orginal method is not able to remove
      # items from these submenus (which is necessary in projectino extensions plugin)
      def remove!(child)
        if @children.include?(child)
          @children.delete(child)
          @last_items_count -= +1 if child && child.last
          child.parent = nil
          child
        else
          @children.each do |item|
            if item.children.include?(child)
              item.children.delete(child)
              child.parent = nil
            end
          end
        end
        child
      end
    end

    def self.included(receiver)
      receiver.class_eval do
        prepend InstanceMethods
        def remove!(child)
          self.remove!(child)
        end
      end
    end
  end
end
unless Redmine::MenuManager::MenuNode.included_modules.include?(RedmineXUxUpgrade::MenuNodePatch)
  Redmine::MenuManager::MenuNode.send(:include, RedmineXUxUpgrade::MenuNodePatch)
end