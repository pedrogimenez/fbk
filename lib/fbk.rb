require "json"
require "nestful"

module FBK
  extend self

  Error = Class.new(RuntimeError)

  FACEBOOK_URL       = "https://facebook.com"
  FACEBOOK_GRAPH_URL = "https://graph.facebook.com/v2.6"

  attr_writer :client_id, :client_secret

  def configure
    yield self
  end

  def authorize_uri(params)
    params[:client_id] = @client_id
    params[:scope] = params[:scope].join(",")

    query_string = params_to_query_string(params)

    "#{FACEBOOK_URL}/dialog/oauth?#{query_string}"
  end

  def get_access_token(params)
    params[:client_id]     = @client_id
    params[:client_secret] = @client_secret

    query_string = params_to_query_string(params)

    response = Nestful.get("#{FACEBOOK_GRAPH_URL}/oauth/access_token?#{query_string}").body
    response = parse_response(response)

    response[:access_token]
  end

  def get_user_info(token)
    get("#{FACEBOOK_GRAPH_URL}/me?access_token=#{token}")
  end

  def get_user_friends(token)
    json = get("#{FACEBOOK_GRAPH_URL}/me/friends?access_token=#{token}")

    return [] if json[:data].empty?

    friends = get_friend_ids(json)

    while json[:paging][:next] do
      json = get(json[:paging][:next])
      friends.concat(get_friend_ids(json))
    end

    friends
  end

  def get_user_picture(token, params = {})
    params[:access_token]  = token
    params[:client_id]     = @client_id
    params[:client_secret] = @client_secret
    params[:redirect]      = false

    query_string = params_to_query_string(params)

    get("#{FACEBOOK_GRAPH_URL}/me/picture?#{query_string}")[:data]
  end

  private

  def get_friend_ids(json)
    json[:data].map { |friend| friend[:id] }
  end

  def get(endpoint)
    response = Nestful.get(endpoint).body
    JSON.parse(response, symbolize_names: true)
  rescue Nestful::BadRequest => error
    raise FBK::Error.new(error.message)
  end

  def params_to_query_string(params)
    params.map { |k,v| "#{k}=#{v}" }.join("&")
  end

  def parse_response(response)
    response.split("&").each_with_object({}) do |parameter, hash|
      key, value = parameter.split("=")
      hash[key.to_sym] = value
    end
  end
end
