# frozen_string_literal: true

require 'mail'

class Mailer
  attr_reader :options

  def initialize(options)
    @options = options
  end

  def send(action, args)
    mail = Mail.new
    mail.content_type 'text/html; charset=UTF-8'
    mail.from = options.fetch(:user_name)

    case action
    when :sandbox_started
      sandbox = args[:sandbox]
      mail.to = sandbox.email
      mail.subject = 'Argo Sandbox'

      toolbox_link = 'https://tda.argo.colossi.network'
      mail.body = <<~html
        <a href="https://github.com/THCLab/sandbox-docs/blob/master/BOOTSTRAPPING_SANDBOX.md">Bootstrapping instruction</a><br>
        <a href="#{toolbox_link}?agent=agent1&uuid=#{sandbox.instance_uuid}">Wallet of agent 1</a><br>
        <a href="#{toolbox_link}?agent=agent2&uuid=#{sandbox.instance_uuid}">Wallet of agent 2</a><br>
        <a href="#{toolbox_link}?agent=agent3&uuid=#{sandbox.instance_uuid}">Wallet of agent 3</a><br>
        <a href="https://editor.oca.argo.colossi.network">OCA Editor</a>

        <br><br>
        Active until #{sandbox.created_at + sandbox.lifetime}
      html
    end

    mail.delivery_method :smtp, options
    mail.deliver!
  end
end
