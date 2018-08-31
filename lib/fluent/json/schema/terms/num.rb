require 'fluent/json/schema/terms/field'


class Fluent::Json::Schema::Terms::Num < Fluent::Json::Schema::Terms::Field

  attr_reader :type, :minimum, :maximum, :exclusive_minimum, :exclusive_maximum, :multiple_of

  def initialize(name, type=:number)
    super(name)
    @type = type
  end

  def set(options={})
    super(options)
    @minimum ||= options[:min]
    @maximum ||= options[:max]
    
    if not options[:exclusive].nil?
      @exclusive_minimum = options[:exclusive].include?(:min)
      @exclusive_maximum = options[:exclusive].include?(:max)
    end

    @multiple_of ||= options[:mult]
    return self
  end

  def as_json
    super({ type: @type }).merge!(
      self.as_json_fragment(
        :minimum, :minimum, :maximum, :exclusive_minimum, 
        :exclusive_maximum, :multiple_of
      )
    )
  end
end