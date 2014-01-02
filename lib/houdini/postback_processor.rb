module Houdini
  module PostbackProcessor
    EnvironmentMismatchError = Class.new RuntimeError
    APIKeyMistmatchError     = Class.new RuntimeError

    def self.process(class_name, model_id, params)
      task_manager = params.delete(:task_manager) || TaskManager

      if params[:environment] != Houdini.environment
        raise EnvironmentMismatchError, "Environment received does not match Houdini.environment"
      end

      if !Rack::Utils.secure_compare(params[:api_key], Houdini.api_key)
        raise APIKeyMistmatchError, "API key received doesn't match our API key."
      end

      task_manager.process class_name, model_id, params[:blueprint], params[:output], params[:verbose_output]
    end
  end
end

unless Rack::Utils.respond_to?(:secure_compare)
  raise "Please upgrade Rack to prevent timing attacks. Requires Rack ~>1.1.6, ~>1.2.8, ~>1.3.10, ~>1.4.5, or >=1.5.2."
end
