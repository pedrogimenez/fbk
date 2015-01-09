# FBK

This probably isn't what you're looking for.

We use this at [Chicisimo](https://github.com/chicisimo).

## Usage

```ruby
require "sinatra"
require "fbk"

get "/login/fb" do
  client_id    = "xxxx"
  redirect_uri = "https://something.com/login/fb/token"

  redirect to("https://www.facebook.com/v2.0/dialog/oauth?client_id=#{client_id}&redirect_uri=#{redirect_uri}")
end

get "/login/fb/token" do
  client_id     = "xxxx"
  client_secret = "xxxx"
  redirect_uri  = "https://something.com/login/fb/token"
  code          = params[:code]

  token = FBK.get_access_token(
    client_id: client_id,
    client_secret: client_secret,
    redirect_uri: redirect_uri,
    code: code) # => "H3UUnvsoymXtinqyofZtHqpqmTNkbJ7x5bpQFeFDGcmAy2THf9pfug2Eyx2ZSTnrqfMcDrUguzaytn4OZHCOyC6RsjEEM2MwHGWGVMwpzuSjWcjE1aS0dVPCTRrNm4bf6YmgVDS7JuUDb3Lxt0AoI0ucTmPdvnbrnkmunszoa0Y9KMJXyh2Nkf4PFgOo2bmjo6rVKzTY"

  user = FBK.get_user_info(token) # => {:id=>"xxxx", :first_name=>"Pedro", :gender=>"male", :last_name=>"Giménez", :link=>"https://www.facebook.com/pedrotgimenez", :locale=>"en_US", :name=>"Pedro Giménez", :timezone=>1, :updated_time=>"1955-02-24T00:00:00+0000", :username=>"pedrotgimenez", :verified=>true}
end
```
