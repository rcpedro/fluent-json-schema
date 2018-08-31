require 'fluent/json/schema/terms/field'


class Fluent::Json::Schema::Terms::Str < Fluent::Json::Schema::Terms::Field
  attr_reader :format, :pattern, :min_length, :max_length

  def initialize(name, options={})
    super(name, options)
  end

  def set(options={})
    super(options)
    @min_length ||= options[:min]
    @max_length ||= options[:max]
    @format ||= options[:fmt]
    @pattern ||= options[:pattern]
    return self
  end

  def datetime
    @format = :'date-time'
  end

  def email
    @format = :email
  end

  def uri
    @format = :uri
  end

  def as_json
    super({ type: :string }).merge!(
      self.as_json_fragment(:min_length, :max_length, :format, :pattern)
    )
  end
end