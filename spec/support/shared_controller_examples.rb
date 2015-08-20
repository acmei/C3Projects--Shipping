# HTTP status code examples ----------------------------------------------------

shared_context "HTTP 200 success" do
  it 'responds with a 200-ok status code' do
    expect(response.status).to eq 200
  end
end

shared_context "HTTP 204 success" do
  it 'responds with a 204-no content status code' do
    expect(response.status).to eq 204
  end
end

shared_context "HTTP 400 client error" do
  it "responds with a 400-bad request status" do
    expect(response).to have_http_status 400
  end
end

shared_context "HTTP JSON response" do
  it "returns a json object" do
    expect(response.header['Content-Type']).to include 'application/json'
  end
end

shared_context "shipping quotes" do
  it "contains an array of quotes" do
    expect(@response["quotes"].class).to eq Array
    # TODO: more?
  end

  context "each quote in the quotes array" do
    before :each do
      @quotes = @response["quotes"]
    end

    it "contains the total cost of shipping" do
      @quotes.each do |quote|
        expect(quote["total_cost"]).to_not be_nil
      end
    end

    it "contains a description of the service type" do
      @quotes.each do |quote|
        expect(quote["service_type"]).to_not be_nil
      end
    end

    it "has a carrier" do
      @quotes.each do |quote|
        expect(quote["carrier"]).to_not be_nil
      end
    end
  end
end

shared_context "shipping query missing parameters" do
  it "responds with a bad request status" do
    expect(response).to have_http_status 400
  end

  context "the returned json object" do
    before :each do
      @response = JSON.parse response.body
    end

    it "sends a helpful error message" do
      expect(@response["message"]).to include("Param is missing")
    end

    it "does not include quotes" do
      expect(@response["quotes"]).to be_nil
    end
  end
end

shared_context "shipping query with bad address" do
  it "responds with a bad request status" do
    expect(response).to have_http_status 400
  end

  context "the returned json object" do
    before :each do
      @response = JSON.parse response.body
    end

    it "sends a helpful error message" do
      expect(@response["message"]).to include("Failure:")
    end

    it "does not include quotes" do
      expect(@response["quotes"]).to be_nil
    end
  end
end
