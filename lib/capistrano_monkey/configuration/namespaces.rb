module Capistrano
  class Configuration
    module Namespaces
      # Describe a new task. If a description is active (see #desc), it is added
      # to the options under the <tt>:desc</tt> key. The new task is added to
      # the namespace.
      def task(name, options={}, &block)
        name = name.to_sym
        raise ArgumentError, "expected a block" unless block_given?

        task_already_defined = tasks.key?(name)
        if all_methods.any? { |m| m.to_sym == name } && !task_already_defined
          thing = namespaces.key?(name) ? "namespace" : "method"

          # Instead of raising an exception here if the task has already been
          # defined (as Cap does by default), we ignore it, so Strano can load.
          next_description(:reset)
          return nil
        end

        task = TaskDefinition.new(name, self, {:desc => next_description(:reset)}.merge(options), &block)
        define_task task
      end
    end
  end
end