# APIClientBase

Abstractions to help author API wrappers in Ruby.

## Installation

- Add `api_client_base` as a dependency to your gem's gemspec.
- `require 'api_client_base'` in `lib/yourgem.rb`

## Usage

This gem assumes your gem will follow a certain structure.

- Actions that your gem can perform are done through a class, like `APIWrapper::Client`.
- Each action has request and response classes.
  - Request class takes care of appending the endpoint's path to the host, preparing params, and specifying the right http method to call
  - Response class takes care of parsing the response and making the data easily accessible for consumption.

### Configuring the gem's base module

Do this:

```ruby
module MyGem
  include APIClientBase::Base.module

  with_configuration do
    has :host, classes: String, default: "https://production.com"
    has :username, classes: String
    has :password, classes: String
  end
end
```

And you can

- configure (thanks to [gem_config](https://github.com/krautcomputing/gem_config)) the gem's base module with defaults:

```ruby
MyGem.configure do |c|
  c.host = "https://test.api.com"
end
```

- instantiate `MyGem::Client` by calling `MyGem.new(host: "https://api.com", username: "user", password: "password")`. If you do not specify an option, it will use the gem's default.

### Configuring the `Client`

#### Default Options

Given this config:

```ruby
module MyGem
  include APIClientBase::Base.module

  with_configuration do
    has :host, classes: String, default: "https://production.com"
    has :username, classes: String
    has :password, classes: String
  end
end
```

Configure the `Client` like this:

```ruby
module MyGem
  class Client
    # specifying a symbol for `default_opts` will look for a method of that name
    # and pass that into the request
    include APIClientBase::Client.module(default_opts: :default_opts)

    private

    def default_opts
      # Pass along all the things your requests need.
      # The methods `host`, `username`, and `password` are available
      # to your `Client` instance because it inherited these from the configuration.
      { host: host, username: username, password: password }
    end
  end
end
```

#### Actions

```ruby
module MyGem
  class Client
    include APIClientBase::Client.module(default_opts: :all_opts)
    api_action :get_user

    # `api_action` basically creates a method like:
    # def get_user(opts={})
    #   request = GetUserRequest.new(all_opts.merge(opts))
    #   raw_response = request.()
    #   GetUserResponse.new(raw_response: raw_response)
    # end

    private

    def all_opts
      { host: "http://prod.com" }
    end
  end
end
```

- `api_action` accepts the method name, and optional hash of arguments. These may contain:
  - `args`: if not defined, the args expected by the method is nothing, or a hash. If given, it must be an array of symbols. For example, if `args: [:id, :name]` is given, then the method defined is effectively: `def my_action(id, name)` but what is passed into the request object is still `{id: "id-value", name: "name-value"}`

You still need to create `MyGem::GetUserRequest` and `MyGem::GetUserResponse`. See the "requests" and "responses" section below.

#### Requests

Requests assume a REST-like structure. This currently does not play well with a SOAP server. You could still use the `Base`, `Client`, and `Response` modules however. For SOAP APIs, write your own Request class that defines `#call`. This method needs to return the `raw_response`.

```ruby
module MyGem
  class GetUserRequest
    # You must install typhoeus if you use the `APIClientBase::Request`. Add it to your gemfile.
    include APIClientBase::Request.module(
      # you may define the action by `action: :post`. Defaults to `:get`.
      # You may also opt to define `#default_action` (see below)
    )

    private

    def path
      # all occurrences of `/:\w+/` in the string will have the matches replaced with the
      # request object's value of that method. For example, if `request.user_id` is 33
      # then you will get "/api/v1/users/33" as the path
      "/api/v1/users/:user_id"

      # Or you can interpolate it yourself if you want
      # "/api/v1/users/#{self.user_id}"
    end

    # Following methods are optional. Override them if you need to send something specific

    def headers
      {"Content-Type" => "application/json"}
    end

    def body
      {secret: "my-secret"}.to_json
    end

    def params
      {my: "params"}
    end

    def default_action
      :post # defaults to :get
    end
  end
end
```

##### Validation

APIClientBase supports validation so that your calls fail early before even hitting the server. The validation library that this supports (by default, and the only one) is dry-validations.

Given this request:

```ruby
module MyGem
  class GetUserRequest
    attribute :user_id, Integer
  end
end
```

Create a dry-validations schema following this pattern:

```ruby
module MyGem
  GetUserRequestSchema = Dry::Validation.Schema do
    required(:user_id).filled(:int?)
  end
end
```

This will raise an error when you call the method:

```
client = MyGem::Client.new #...
client.get_user(user_id: nil) # -> this raises an ArgumentError "[user_id: 'must be filled']"
```

#### Responses

```ruby
module MyGem
  class GetUserResponse
    include APIClientBase::Response.module
    # - has `#status` method that is delegated to `raw_response.status`
    # - has `#code` method to get the response's code
    # - has `#raw_response` which is a Typhoeus response object

    # You're encouraged to use Virtus attributes to extract information cleanly
    attribute :id, Integer, lazy: true, default: :default_id
    attribute :name, String, lazy: true, default: :default_name
    attribute :body, Object, lazy: true, default: :default_body

    private

    # Optional: define `#default_success` to determine what it means for
    # the response to be successful. For example, the code might be 200
    # but you consider it a failed call if there are no results
    def default_success
      code == 200 && !body[:users].empty?
    end

    def default_body
      JSON.parse(raw_response.body).with_indifferent_access
    end

    def default_id
      body[:id]
    end

    def default_name
      body[:name]
    end
  end
end
```

You can an example gem at https://github.com/imacchiato/bridge_client-ruby.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/imacchiato/api_client-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
