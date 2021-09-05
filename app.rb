# frozen_string_literal: true

require 'bundler/setup'
Bundler.require

module LambdaFunction
  class Handler
    def self.process(event:, context:)
      client = Mysql2::Client.new(db_config)
      results = client.query("SHOW DATABASES;").to_a
      puts results
    end

    def self.db_config
      return dev_db_config unless ENV['USE_AWS']

      ssm_client = Aws::SSM::Client.new(region: ENV['AWS_REGION'])

      {
        host: ssm_client.get_parameter(name: '/mysql-connect/DB_HOST', with_decryption: true).parameter.value,
        username: ssm_client.get_parameter(name: '/mysql-connect/DB_USER', with_decryption: true).parameter.value,
        password: ssm_client.get_parameter(name: '/mysql-connect/DB_PASSWORD', with_decryption: true).parameter.value,
        database: ssm_client.get_parameter(name: '/mysql-connect/DB_NAME', with_decryption: true).parameter.value
      }
    end

    def self.dev_db_config
      {
        host: ENV["DB_HOST"],
        username: ENV["DB_USER"],
        password: ENV["DB_PASSWORD"],
        database: ENV["DB_NAME"]
      }
    end
  end
end
