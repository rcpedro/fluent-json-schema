require 'spec_helper'


RSpec.describe Fluent::Json::Schema::Terms::Obj do
  describe 'nested' do
    before(:all) do
      @home = Fluent::Json::Schema::Terms::Obj.new(:home)

      @home
        .req
          .obj(:address) { |addr|
            addr
              .req.strs(:city, :country)
              .opt.strs(:name, :street)
          }
          .obj(:owner) { |owner|
            owner
              .req.str(:email)
              .opt.strs(:name, :contact_no)
          }
    end

    subject { @home }

    it { expect(subject.as_json).to eq({
      type: :object,
      additionalProperties: false,
      required: [
        :address, :owner
      ],
      properties: {
        address: {
          type: :object,
          additionalProperties: false,
          required: [:city, :country],
          properties: {
            city:    { type: :string },
            country: { type: :string },
            name:    { type: :string },
            street:  { type: :string }
          }
        },
        owner: {
          type: :object,
          additionalProperties: false,
          required: [:email],
          properties: {
            email: { type: :string },
            name: { type: :string },
            contact_no: { type: :string }
          }
        }
      }
    })}
  end

  describe 'basic' do
    before(:all) do
      @basic = Fluent::Json::Schema::Terms::Obj.new(:user)
      @basic
        .req
          .strs(:first_name, :last_name, :username, :contact_no, :email, status: { enum: ["active", "inactive"]})
          .bools(:super)
          .dates(:created_at, :updated_at)
        .opt
          .strs(:created_by, :updated_by)
    end

    subject { @basic }

    it do 
      expect(subject.as_json).to eq({
        type: :object,
        additionalProperties: false,
        required: [
          :first_name, :last_name, :username, :contact_no, :email, 
          :status, :super, :created_at, :updated_at
        ],
        properties: {
          first_name: { type: :string },
          last_name:  { type: :string },
          email:      { type: :string },
          username:   { type: :string },
          contact_no: { type: :string },
          status:     { type: :string, enum: ["active", "inactive"] },
          super:      { type: :boolean },
          created_at: { type: :string, format: 'date-time' },
          updated_at: { type: :string, format: 'date-time' },
          created_by: { type: :string },
          updated_by: { type: :string }
        }
      })
    end
  end

  describe 'user' do
    before(:all) do
      @user = Fluent::Json::Schema::Terms::Obj.new(:user)
      @user.lookup(User)
           .reflect(
              :first_name, :last_name, :email, :username, :contact_no,
              :super, :status, :created_by, :updated_by, :created_at,
              :updated_at
            )
    end
    
    subject { @user }

    it { expect(subject.name).to        eq(:user) }
    it { expect(subject.klass).to       eq(User) }
    it { expect(subject.fields.size).to eq(11) }

    it { expect(subject[:first_name].class).to eq(Fluent::Json::Schema::Terms::Reflect) }

    it { expect(subject[:first_name].as_json).to eq({ type: :string }) }
    it { expect(subject[:last_name].as_json).to  eq({ type: :string }) }
    it { expect(subject[:email].as_json).to      eq({ type: :string }) }
    it { expect(subject[:username].as_json).to   eq({ type: :string }) }
    it { expect(subject[:contact_no].as_json).to eq({ type: :string }) }

    it { expect(subject[:super].as_json).to   eq({ type: :boolean }) }
    it { expect(subject[:status].as_json).to  eq({ type: :string, enum: ["active", "inactive"] }) }

    it { expect(subject[:created_by].as_json).to eq({ type: :string }) }
    it { expect(subject[:updated_by].as_json).to eq({ type: :string }) }

    it { expect(subject[:created_at].as_json).to eq({ type: :string, format: 'date-time' })}
    it { expect(subject[:updated_at].as_json).to eq({ type: :string, format: 'date-time' })}

    it do 
      expect(subject.as_json).to eq({
        type: :object,
        additionalProperties: false,
        required: [
          :first_name, :last_name, :email, :username, :super, :status, 
          :created_by, :updated_by, :created_at, :updated_at
        ],

        properties: {
          first_name: { type: :string },
          last_name:  { type: :string },
          email:      { type: :string },
          username:   { type: :string },
          contact_no: { type: :string },
          super:      { type: :boolean },
          status:     { type: :string, enum: ["active", "inactive"] },
          created_by: { type: :string },
          updated_by: { type: :string },
          created_at: { type: :string, format: 'date-time' },
          updated_at: { type: :string, format: 'date-time' }
        }
      })
    end
  end
end