require "json"
require "nestful"

module FBK
  extend self

  FACEBOOK_URL       = "https://facebook.com"
  FACEBOOK_GRAPH_URL = "https://graph.facebook.com/v2.0"

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

    friends = get_friends_ids(json)

    return friends if only_one_page?(friends, json)

    while (json = get(json[:paging][:next])) && !json[:data].empty? do
      friends += get_friends_ids(json)
    end

    friends
  end

  def get_user_picture(user_id, params)
    params[:client_id]     = @client_id
    params[:client_secret] = @client_secret
    params[:redirect]      = false

    query_string = params_to_query_string(params)

    get("#{FACEBOOK_GRAPH_URL}/#{user_id}/picture?#{query_string}")
  end

  private

  def get_friends_ids(json)
    json[:data].map { |friend| friend[:id] }
  end

  def only_one_page?(friends, json)
    friends.count == json[:summary][:total_count]
  end

  def get(endpoint)
    response = Nestful.get(endpoint).body
    JSON.parse(response, symbolize_names: true)
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
