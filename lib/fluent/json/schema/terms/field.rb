require 'fluent/json/schema/terms'


class Fluent::Json::Schema::Terms::Field
  
  attr_reader :version, :name, :required, :enum, :default, :constraints

  def initialize(name, options={})
    @name = name
    @required = false
    @constraints = []

    self.set(options)
  end

  def mandate
    @required = true
    return self
  end

  def optionalise
    @required = false
    return self
  end

  def set(options={})
    @enum = options[:enum]
    @default = options[:default]
  end

  def as_json(options={})
    return options.merge(self.as_json_fragment(:default, :enum))
  end

  protected
    def as_json_fragment(*names)
      result = {}

      names.each do |name|
        value = self.send(name)
        result[name] = value if value.present?
      end

      return result
    end
end