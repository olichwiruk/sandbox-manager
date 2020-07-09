require 'redis'
require 'roda'

class Web < Roda
  plugin :json

  redis = Redis.new(host: 'tda-init-redis', port: 6379)

  route do |r|
    r.on 'api' do
      r.on 'v1' do
        r.on 'run' do
          r.post do
            service = ::Services::RunSandboxService.new(redis)
            service.call(r.params)
          end
        end
      end
    end
  end
end
