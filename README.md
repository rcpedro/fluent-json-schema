# Fluent::Json::Schema

Build [json schemas](https://json-schema.org/) fluently.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-json-schema', git: 'https://github.com/rcpedro/fluent-json-schema.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-json-schema

## Usage

### Basic Usage

Given:

```ruby
basic = Fluent::Json::Schema::Terms::Obj.new(:user)
basic
  .req
    .strs(:first_name, :last_name, :username, :contact_no, :email, status: { enum: ["active", "inactive"]})
    .bools(:super)
    .dates(:created_at, :updated_at)
  .opt
    .strs(:created_by, :updated_by)
```

Calling `as_json` would give the following result:

```ruby
{
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
}
```

### Nested Objects

Given:

```ruby
home = Fluent::Json::Schema::Terms::Obj.new(:home)

home
  .req
    .obj(:address) { |address|
      address
        .req.strs(:city, :country)
        .opt.strs(:name, :street)
    }
    .obj(:owner) { |owner|
      owner
        .req.str(:first_name, :last_name, email: { fmt: :email }) 
        .opt.strs(:title, :contact_no)
    }
  .opt
    .date(:date_built)
```

Calling `as_json` would give the following result:

```ruby
{
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
      required: [:first_name, :last_name, :email],
      properties: {
        email:      { type: :string, format: :email },
        title:      { type: :string },
        first_name: { type: :string },
        last_name:  { type: :string },
        contact_no: { type: :string }
      }
    },
    date_built: {
      type: :string,
      format: :'date-time'
    }
  }
}
```

### With Active Record

Given:

```ruby
user = Fluent::Json::Schema::Terms::Obj.new(:user)
user.lookup(User)
    .reflect(
      :first_name, :last_name, :email, :username, :contact_no,
      :super, :status, :created_by, :updated_by, :created_at,
      :updated_at
    )
```

Calling `as_json` would give the following result:

```ruby
{
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
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rcpedro/fluent-json-schema.

