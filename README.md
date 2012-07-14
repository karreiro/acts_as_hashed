# ActsAsHashed

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_hashed'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_hashed

## Usage

#### Run your migrations for the desired models

```ruby
class AddHashedCodeToSeller < ActiveRecord::Migration
  def self.up
    add_column :sellers, :hashed_code, :string
  end

  def self.down
    remove_column :sellers, :hashed_code, :string
  end
end
```

### Usage

#### In your model:

```ruby
class Seller < ActiveRecord::Base
  acts_as_hashed

  ...
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
