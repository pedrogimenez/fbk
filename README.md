# FBK

You can use this library to implement Facebook login in your Ruby application.

We use this at [Chicisimo](https://github.com/chicisimo).

## Usage

```ruby
require "sinatra"
require "fbk"

REDIRECT_URI = "https://something.com/login/fb/token"

FBK.configure do |config|
  config.client_id     = "xxx"
  config.client_secret = "xxx"
end

get "/login/fb" do
  redirect to(FBK.authorize_uri(redirect_uri: REDIRECT_URI, scope: %w{public_profile}))
end

get "/login/fb/token" do
  code = params[:code]

  access_token = FBK.get_access_token(redirect_uri: REDIRECT_URI, code: code) # => "H3UUnvsoymXtinqyofZtHqpqmTNkbJ7x5bpQFeFDGcmAy2THf9pfug2Eyx2ZSTnrqfMcDrUguzaytn4OZHCOyC6RsjEEM2MwHGWGVMwpzuSjWcjE1aS0dVPCTRrNm4bf6YmgVDS7JuUDb3Lxt0AoI0ucTmPdvnbrnkmunszoa0Y9KMJXyh2Nkf4PFgOo2bmjo6rVKzTY"

  user = FBK.get_user_info(access_token) # => {:id=>"xxxx", :first_name=>"Pedro", :gender=>"male", :last_name=>"Giménez", :link=>"https://www.facebook.com/pedrotgimenez", :locale=>"en_US", :name=>"Pedro Giménez", :timezone=>1, :updated_time=>"1955-02-24T00:00:00+0000", :username=>"pedrotgimenez", :verified=>true}
end
```
