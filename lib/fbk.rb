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
    response = Nestful.get("#{FACEBOOK_GRAPH_URL}/me?access_token=#{token}").body
    JSON.parse(response, symbolize_names: true)
  end

  private

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
