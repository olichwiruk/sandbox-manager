# frozen_string_literal: true

require 'domain/script'

module Services
  class RunSandboxService
    attr_reader :redis

    def initialize(redis)
      @redis = redis
    end

    def call(params)
      valid_params = validate(params)
      return { success: false, errors: ['invalid params'] } unless valid_params

      token = generate_token
      script = Script.load(
        path: File.join(LIB_PATH, 'scripts', 'run_sandbox.sh'),
        variables: {
          token: token,
          sandbox_path: "#{SANDBOX_PATH}",
          sandbox_dir: "#{ROOT_PATH}/sandbox",
          templates_dir: "#{ROOT_PATH}/templates",
          nginx_dir: "#{ROOT_PATH}/nginx_conf"
        }
      )
      script.run
      {
        success: true,
        data: {
          token: token
        }
      }
    end

    private def generate_token
      rand(36**6).to_s(36)
    end

    private def validate(params)
      return unless params['email']
      {
        email: params['email']
      }
    end
  end
end
