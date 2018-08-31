require 'fluent/json/schema/terms/num'


class Fluent::Json::Schema::Terms::Int < Fluent::Json::Schema::Terms::Num
  
  def initialize(name)
    super(name, :integer)
  end
end