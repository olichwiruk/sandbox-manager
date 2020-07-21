# frozen_string_literal: true

module Services
  class RunSandboxService
    attr_reader :sandbox_repo

    def initialize(sandbox_repo)
      @sandbox_repo = sandbox_repo
    end

    def call(params)
      valid_params = validate(params)
      return { success: false, errors: ['invalid params'] } unless valid_params
      email = valid_params.fetch(:email)
      sandbox = Entities::Sandbox.create(email: email)

      script = Entities::Script.load(
        path: File.join(LIB_PATH, 'scripts', 'run_sandbox.sh'),
        variables: {
          token: sandbox.instance_uuid,
          sandbox_path: "#{SANDBOX_PATH}",
          sandbox_dir: "#{ROOT_PATH}/sandbox",
          templates_dir: "#{ROOT_PATH}/templates",
          nginx_dir: "#{ROOT_PATH}/nginx_conf"
        }
      )
      run_successfully = script.run

      if run_successfully
        sandbox_repo.save(sandbox)
        { success: true, data: sandbox.to_h }
      else
        { success: false, errors: ['script failed'] }
      end
    end

    private def validate(params)
      return unless params['email']
      {
        email: params['email']
      }
    end
  end
end
