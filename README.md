# ActsAsHashed

ActsAsHashed is helpful to set a hash_code column based on SecureRandom.hex(16).

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_hashed'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_hashed

## Usage

### In your model:

```ruby
class Order < ActiveRecord::Base
  acts_as_hashed

  ...
end
```

If you want to use the *hashed_code* instead of *id* on URLs:

```ruby
class Order < ActiveRecord::Base
  acts_as_hashed

  def to_param
    hashed_code
  end

  ...
end
```

You can overwrite the method that generates the hash.

```ruby
class Order < ActiveRecord::Base
  acts_as_hashed

  class << self
    def friendly_token
      SecureRandom.hex(5)
    end
  end
end
```

### Create your migrations for the desired models

```bash
$ rails g migration AddHashedCodeToOrders hashed_code:string
```

Update your migration to add Model.update_missing_hashed_code

```ruby
class AddHashedCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :hashed_code, :string
    Order.reset_column_information
    Order.update_missing_hashed_code
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

ActsAsHashed is maintained and funded by [HE:labs](http://helabs.com.br/opensource/).
Thank you to all the [contributors](https://github.com/Helabs/acts_as_hashed/graphs/contributors).

## License

ActsAsHashed is Copyright © 2012-2014 HE:labs. It is free software, and may be redistributed under the terms specified in the LICENSE file.