require 'redis'
require 'roda'

class Web < Roda
  plugin :json

  redis = Redis.new(host: 'tda-init-redis', port: 6379)

  route do |r|
    r.on 'api' do
      r.on 'v1' do
        r.on 'run' do
          r.is do
            service = ::Services::RunSandboxService.new
            service.call
          end
        end
      end
    end
  end
end
