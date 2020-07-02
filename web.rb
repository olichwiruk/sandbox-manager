require 'roda'

class Web < Roda
  plugin :json

  route do |r|
    r.on 'api' do
      r.on 'v1' do
        r.on 'hello' do
          'hello world'
        end
      end
    end
  end
end
