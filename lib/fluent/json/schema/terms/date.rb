require 'fluent/json/schema/terms/str'


class Fluent::Json::Schema::Terms::Date < Fluent::Json::Schema::Terms::Str
  
  def initialize(name)
    super(name)
    self.datetime
  end

  def format
    return :'date-time'
  end
end