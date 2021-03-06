# Unscoped Associations

[![Gem Version](https://badge.fury.io/rb/unscoped_associations.svg)](http://badge.fury.io/rb/unscoped_associations)
[![Build Status](https://travis-ci.org/markets/unscoped_associations.svg?branch=master)](https://travis-ci.org/markets/unscoped_associations)

Do you need to skip the `default_scope` when you fetch objects through associations (for some strange reasons)? Do it easily with this lib!

Supported associations:

* `:belongs_to`
* `:has_one`
* `:has_many`

## Installation

Add this line to your Gemfile:

```ruby
gem 'unscoped_associations'
```

Or install the gem manually:

```ruby
gem install unscoped_associations
```

## Usage

Basic usage example:

```ruby
class User < ActiveRecord::Base
  has_many :comments # or , unscoped: false
  has_many :all_comments, class_name: 'Comment', unscoped: true
  has_one  :last_comment, class_name: 'Comment', order: 'created_at DESC', unscoped: true

  default_scope { where(active: true) }
end

class Comment < ActiveRecord::Base
  belongs_to :user, unscoped: true

  default_scope { where(public: true) }
end

@user.comments # => return public comments
@user.all_comments # => return all comments skipping default_scope
@user.last_comment # => return last comment skipping default_scope
@comment.user # => return user w/o taking account 'active' flag

```

## Status

Tested on Rails 3 series and Rails 4. Originally was thought and built for Rails 3, but Rails 4 is also supported.

Rails 4 introduces some updates regarding this part. For example, in Rails 4, you are able to customize associations using a scope block (overriding conditions), so you can skip the `default_scope` conditions by:

```ruby
class User < ActiveRecord::Base
  has_many :all_comments, -> { where(public: [true, false]) }, class_name: 'Comment'
end
```

Since Rails 4.1, you can override default conditions using `unscope` method:

```ruby
class User < ActiveRecord::Base
  has_many :all_comments, -> { unscope(where: :public) }, class_name: 'Comment'
end
```

Anyway, you can continue using `unscoped_associations`, still useful if you prefer to bypass the entire `default_scope`, if it's a scope with multiple conditions, like:

```ruby
default_scope { where(public: true).order(:updated_at) }
```

## Contributing

Ideas, fixes, improvements or any comment are welcome!

## License

Copyright (c) 2013-2015 Marc Anguera. Unscoped Associations is released under the [MIT](LICENSE) License.
