# frozen_string_literal: true

module Entities
  class Sandbox
    attr_reader :email, :token, :created_at, :lifetime, :active

    def initialize(email:, token:, created_at:, lifetime:, active:)
      @email = email
      @token = token
      @created_at = Time.parse(created_at.to_s)
      @lifetime = lifetime.to_i
      @active = active.to_s == 'true'
    end

    class << self
      def create(email:)
        new(email: email,
            token: generate_token,
            created_at: Time.now,
            lifetime: 24*3600,
            active: true)
      end

      private def generate_token
        rand(36**6).to_s(36)
      end
    end

    def inactivate
      @active = false
    end

    def overdue?
      created_at + lifetime < Time.now
    end

    def to_h
      {
        email: email,
        token: token,
        created_at: created_at,
        lifetime: lifetime,
        active: active
      }
    end
  end
end
