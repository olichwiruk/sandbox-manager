# frozen_string_literal: true

module Entities
  class Script
    attr_reader :content
    private :content

    def initialize(content)
      @content = content
    end

    def self.load(path:, variables:)
      content = File.read(path)
      variables.each do |k, v|
        content.gsub!("%{#{k.upcase}}", v)
      end
      new(content)
    end

    def run
      system('bash', '-c', content)
    end
  end
end
