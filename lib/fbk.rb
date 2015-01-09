require "json"
require "nestful"

class FBK
  FACEBOOK_URL = "https://graph.facebook.com"

  def self.get_access_token(params)
    query = parse_params(params)

    response = Nestful.get("#{FACEBOOK_URL}/oauth/access_token?#{query}").body
    response = parse_response(response)

    response[:access_token]
  end

  def self.get_user_info(token)
    response = Nestful.get("#{FACEBOOK_URL}/me?access_token=#{token}")
    JSON.parse(response.body, symbolize_names: true)
  end

  private

  def self.parse_params(params)
    params.each_with_object([]) { |(k,v), query| query << "#{k}=#{v}" }.join("&")
  end

  def self.parse_response(response)
    response.split("&").each_with_object({}) do |parameter, hash|
      key, value = parameter.split("=")
      hash[key.to_sym] = value
    end
  end

  private_class_method :parse_params, :parse_response
end
