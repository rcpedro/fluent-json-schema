require 'fluent/json/schema/terms'
require 'fluent/json/schema/lexicon'
require 'fluent/json/schema/terms/field'


class Fluent::Json::Schema::Terms::Obj < Fluent::Json::Schema::Terms::Field
  include Fluent

  lexicon Fluent::Json::Schema::Lexicon.instance

  attr_reader :name, :fields, :klass, :additional

  def initialize(name)
    super(name)
    @fields = {}
    @additional = false
    @mode = :optional
  end

  def req
    @mode = :req 
    return self
  end

  def opt
    @mode = :opt 
    return self
  end

  def add(field)
    @fields[field.name] = self.prepare(field)
  end

  def [](prop)
    return @fields[prop]
  end

  def open(allowed=nil)
    @additional = allowed if allowed.present?
    @additional ||= true
    return self
  end

  def strict
    @additional = false
    return self
  end

  def lookup(klass)
    @name ||= klass.table_name.to_sym
    @klass = klass
    return self
  end

  def reflect(*props)
    raise 'No lookup defined' if @klass.nil?
    
    @mode = nil
    props.each { |prop| @fields[prop] = Fluent::Json::Schema::Terms::Reflect.new(prop, @klass) }
    return self
  end

  def requirements
    return @fields.map { |k, field| field if field.required }.compact
    return []
  end

  def as_json
    fragment = super.merge!({
      type: :object,
      additionalProperties: @additional,
      required: self.requirements.map { |r| r.name },
      properties: {}
    })

    @fields.map { |k, v| fragment[:properties][k] = v.as_json }

    return fragment
  end

  protected
    def prepare(field)
      case @mode
      when :req
        return field.mandate
      when :opt
        return field.optionalise
      end
      
      return field
    end
end