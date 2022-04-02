require 'securerandom'

module Mzr
  class ApiError < StandardError
    attr_accessor :resource, :object, :request, :response, :add_context, :add_error_context

    def initialize(attributes={})      
      @controller = attributes[:controller]
      @object = attributes[:object]
      @resource = attributes[:resource] || 'Resource'
      @subcode = attributes[:subcode]
      @override_detail = attributes[:override_detail]
      @override_status = attributes[:override_status]
      @add_context = attributes[:add_context] || {}
      @add_error_context = attributes[:add_error_context] || {}
      @request = @controller.try(:request)
      @response = @controller.try(:response)
      set_resource
    end

    def sub_errors
      return [] unless @object.present?
      return [] unless @object&.errors&.full_messages.present?

      attributes = @object.errors.details.map(&:first)
      @sub_errors = []

      attributes.each do |atr|
        @object.errors.full_messages_for(atr).each do |msg|
          error = {pointer: atr.to_s }
          error_with_message = error.merge(detail: msg)
          @sub_errors << error_with_message
        end
      end
      @sub_errors 
    end

    def status(status: 422)
      @override_status&.integer? ? @override_status : status
    end

    def message
      raise NotImplementedError, 'Message must be implemented. Add Error message method'
    end

    def subcodes(hash=nil)
      return {} if hash.blank?

      hash.with_indifferent_access
    end

    def subcode
      return '' unless subcodes[@subcode].present?

      @subcode.to_s.camelcase
    end

    def detail
      return '' unless @override_detail.present? || subcodes[@subcode].present?

      @override_detail.present? ? @override_detail : subcodes[@subcode]
    end

    def trace_id
      trace_id ||= SecureRandom.hex(trace_id_length).upcase
    end

    def type
      self.class.name.split('::').last
    end

    def render
      {
        error: { 
          trace_id: trace_id,
          type: type, 
          message: message,
          error_subcode: subcode, 
          detail: detail,
          sub_errors: sub_errors,
        }.merge(add_error_context)
      }.merge(add_context)
    end

    private

    def trace_id_length
      Mzr::Api::Error.configuration.trace_id_length / 2
    end

    def set_resource
      return unless @object.present?
      return unless @object&.errors&.full_messages.present?

      @resource = @object.class.name.split('::').last if @resource == 'Resource'
    end
  end
end
