require 'spec_helper'

describe Fluent::Json::Schema do
  it 'has a version number' do
    expect(Fluent::Json::Schema::VERSION).not_to be nil
  end

  describe 'library' do
    it { expect(Fluent::Json::Schema::Terms::Bool.new(:test)).not_to be nil }
    it { expect(Fluent::Json::Schema::Terms::Date.new(:test)).not_to be nil }
    it { expect(Fluent::Json::Schema::Terms::Field.new(:test)).not_to be nil }
    it { expect(Fluent::Json::Schema::Terms::Fk.new(:test)).not_to be nil }
    it { expect(Fluent::Json::Schema::Terms::Int.new(:test)).not_to be nil }
    it { expect(Fluent::Json::Schema::Terms::Num.new(:test)).not_to be nil }
    it { expect(Fluent::Json::Schema::Terms::Obj.new(:test)).not_to be nil }
    it { expect(Fluent::Json::Schema::Terms::Reflect.new(:email, User)).not_to be nil }
    it { expect(Fluent::Json::Schema::Terms::Str.new(:test)).not_to be nil }
  end
end
