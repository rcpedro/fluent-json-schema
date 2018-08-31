require 'fluent/json/schema/terms/field'


class Fluent::Json::Schema::Terms::Fk < Fluent::Json::Schema::Terms::Field

  def as_json
    super({ type: :int })
  end
end