# activerecord-sharding-facade

helper module for activerecord-sharding.
original codes by [YuukiARIA](https://github.com/YuukiARIA) ref [#28](https://github.com/hirocaster/activerecord-sharding/pull/28)

## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-sharding-facade'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-sharding-facade

## for users

Write every times config for activerecord-sharding to many models.

``` ruby
class Model < ActiveRecord::Base

  include ActiveRecord::Sharding::Model
  include ActiveRecord::Sharding::Sequencer

  use_sharding :user, :modulo # shard name, algorithm
  define_sharding_key :id
  use_sequencer :user

  before_put do |attributes|
    attributes[:id] = next_sequence_id unless attributes[:id]
  end

  before_save on: :create do
    self.id ||= self.class.next_sequence_id
  end
end
```

this module, replaced codes.

``` ruby
class Model < ActiveRecord::Base
  include ActiveRecord::Sharding::Facade # here!!!

  use_sharding :user, :modulo # shard name, algorithm
  define_sharding_key :id
  use_sequencer :user
end
```

You must consider this when you implement hooks for models.

``` ruby
before_put do |attributes|
  attributes[:id] = next_sequence_id unless attributes[:id]
end

before_save on: :create do
  self.id ||= self.class.next_sequence_id
end
```
