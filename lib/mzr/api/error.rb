require "mzr/api/error/version"
require "mzr/configuration"
require "mzr/api_error"

module Mzr
  module Api
    module Error
      class << self
        def configuration
          @configuration ||= Configuration.new
        end

        def configure
          yield(configuration)
          load 'mzr/api/error/engine'
        end

        def all_errors
          return [] if self.configuration.namespaces.blank?

          self.configuration.namespaces.map(&:constantize).map do |namespace|
            namespace.constants.map { |x| {namespace: namespace, name: x.to_s.underscore } }
          end.flatten
        end
      end
    end
  end
end
