module Capistrano
  class CLI
    def execute_requested_actions(config)
      Array(options[:vars]).each { |name, value| config.set(name, value); }

      Array(options[:actions]).each do |action|
        config.find_and_execute_task(action, :before => :start, :after => :finish)
        # reload `-s var=value` vars if in multistage as stage is loaded as action (after vars have been set)
        if config.namespaces.keys.include?(:multistage) && config.stages.include?(action)
          Array(options[:vars]).each { |name, value| config.set(name, value) }
        end
      end
    end
  end
end
