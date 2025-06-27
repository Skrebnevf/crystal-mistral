require "./spec_helper"
require "../src/crystal-mistral/client"
require "webmock"
require "./mock_data.cr"

url = "https://api.mistral.ai"
api_key = "test-key"
model = "mistral-model"

describe CrystalMistral do
  headers = HTTP::Headers{
    "Authorization" => "Bearer #{api_key}",
    "Content-Type"  => "application/json",
    "Accept"        => "application/json",
  }

  before_each do
    WebMock.reset
  end

  it "raises APIError on 400 response" do
    WebMock.stub(:post, "#{url}/v1/chat/completions")
      .with(headers: headers)
      .to_return(
        status: 400,
        body: ERROR_400_RESPONSE
      )

    client = CrystalMistral::Client.new api_key

    expect_raises(Exception, /400.*message: .*model.*code: \d+/) do
      client.chat(
        model: "mistral-small-250",
        messages: STRING_MESSAGE,
        temperature: 1.1_f32
      )
    end
  end

  it "raises APIError on 422 response" do
    WebMock.stub(:post, "#{url}/v1/chat/completions")
      .with(headers: headers)
      .to_return(
        status: 422,
        body: ERROR_422_RESPONSE
      )

    client = CrystalMistral::Client.new api_key

    expect_raises(Exception, /422.*message: Input should be less than or equal to 1.5/) do
      client.chat(
        model: "mistral-small-250",
        messages: STRING_MESSAGE,
        temperature: 12_f32
      )
    end
  end
end
