# frozen_string_literal: true

require 'domain/script'

module Services
  class StopOverdueSandboxesService
    attr_reader :redis

    def initialize(redis)
      @redis = redis
    end

    def call
      stopped = []
      failed = []
      overdue_records.each do |record|
        script = Script.load(
          path: File.join(LIB_PATH, 'scripts', 'stop_sandbox.sh'),
          variables: {
            token: record[:token],
            sandbox_dir: "#{ROOT_PATH}/sandbox",
            nginx_dir: "#{ROOT_PATH}/nginx_conf"
          }
        )
        run_successfully = script.run

        if run_successfully
          redis.set("#{record[:email]}:active", false)
          stopped << record.slice(:email, :token, :created_at, :lifetime)
        else
          failed << record.slice(:email, :token, :created_at, :lifetime)
        end
      end

      {
        success: true,
        data: { stopped: stopped, failed: failed }
      }
    end

    private def overdue_records
      all_records.select do |record|
        created_at = Time.parse(record[:created_at])
        lifetime = record[:lifetime].to_i
        record[:active] == 'true' && created_at + lifetime < Time.now
      end
    end

    private def all_records
      _, email_keys = redis.scan(0, match: '*:token')
      emails = email_keys.map { |k| k.split(':')[0] }
      emails.map do |email|
        _, keys = redis.scan(0, match: "#{email}:*")
        values = redis.mget(keys)
        keys.each_with_object(email: email).with_index do |(key, memo), i|
          memo[key.split(':')[1].to_sym] = values[i]
        end
      end
    end
  end
end
