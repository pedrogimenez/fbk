require_relative "../lib/fbk"

describe FBK do
  TOKEN = "xxxx"

  describe "#get_user_friends" do
    FRIENDS_ENDPOINT = "#{FBK::FACEBOOK_GRAPH_URL}/me/friends?access_token=#{TOKEN}"

    it "returns the user friends when there's only one page of friends" do
      expect(Nestful).to receive(:get).with(FRIENDS_ENDPOINT).and_return(build_response("single_page_friends"))

      expect(FBK.get_user_friends(TOKEN)).to eq(["1", "2"])
    end

    it "returns the user friends when there are multiple pages of friends" do
      expect(Nestful).to receive(:get).with(FRIENDS_ENDPOINT).and_return(build_response("multi_page_friends_one"))
      expect(Nestful).to receive(:get).with("irrelevant").and_return(build_response("multi_page_friends_two"))

      expect(FBK.get_user_friends(TOKEN)).to eq(["1", "2"])
    end

    it "returns an empty array when no data is received" do
      expect(Nestful).to receive(:get).with(FRIENDS_ENDPOINT).and_return(build_response("no_data"))

      expect(FBK.get_user_friends(TOKEN)).to eq([])
    end
  end

  def build_response(file)
    double(body: File.read(File.expand_path("../fixtures/#{file}.json", __FILE__)))
  end
end
