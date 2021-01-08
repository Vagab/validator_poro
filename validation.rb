class ValidationError < StandardError
  def initialize(attribute, msg='Validation failed on ')
    msg = msg + attribute.to_s
    super(msg)
  end
end

module Validation
  module ClassValidations
    @@validators = {}

    def validate(attribute, options={})
      @@validators[attribute] = options
    end

    def self.validators
      @@validators
    end
  end

  def self.included(klass)
    klass.extend(ClassValidations)
  end

  def validate!
    validate
    raise ValidationError.new(@errors.join(', ')) unless @errors.empty?
  end

  def valid?
    validate
    @errors.empty?
  end

  def validate_attribute(attribute, options)
    value = send(attribute)
    options.keys.each do |key|
      case key
      when :presence
        if options[:presence] && (value.nil? || (value.empty? if value.is_a? String))
          @errors << attribute unless @errors.include? attribute
        end
      when :format
        if !value.is_a?(String) || value.nil? || !value.match?(options[:format])
          @errors << attribute unless @errors.include? attribute
        end
      when :type
        unless value.is_a? options[:type]
          @errors << attribute unless @errors.include? attribute
        end
      end
    end
  end

  private

  def validate
    @errors = []
    ClassValidations.validators.each do |attribute, options|
      validate_attribute(attribute, options)
    end
  end
end
