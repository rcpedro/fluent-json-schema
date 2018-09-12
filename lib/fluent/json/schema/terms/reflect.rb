require 'fluent/json/schema/terms'


class Fluent::Json::Schema::Terms::Reflect < SimpleDelegator

  MAPPINGS = {
    string:   Fluent::Json::Schema::Terms::Str,
    datetime: Fluent::Json::Schema::Terms::Date,
    date:     Fluent::Json::Schema::Terms::Date,
    time:     Fluent::Json::Schema::Terms::Date,
    integer:  Fluent::Json::Schema::Terms::Int,
    decimal:  Fluent::Json::Schema::Terms::Num,
    boolean:  Fluent::Json::Schema::Terms::Bool
  }

  attr_reader :klass, :instance

  def initialize(name, klass)
    @klass = klass
    # TODO, fk
    
    column = klass.columns_hash[name.to_s]
    raise "Column with name '#{name}' not found in '#{klass.name}'" if column.nil?

    enum = klass.defined_enums[name.to_s]
    instance_klass = MAPPINGS[column.type.to_sym]
    instance_klass = MAPPINGS[:string] if enum.present? and enum.keys[0].is_a?(String)

    raise "Unsupported type '#{column.type}' for '#{name}'" if instance_klass.nil?
    
    @instance = instance_klass.new(name)
    @instance.set(enum: enum.keys) if enum.present?
    @instance.require if not column.null

    super(@instance)
  end
end