require 'fluent/json/schema/terms/field'


class Fluent::Json::Schema::Terms::Bool < Fluent::Json::Schema::Terms::Field
  
  def as_json
    super({ type: :boolean })
  end
end