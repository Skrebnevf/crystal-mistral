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

  cases = [
    TestCase.new(
      name: "with dialog",
      input: DIALOG_MESSAGE,
      model: "mistral-small-2503"
    ),
    TestCase.new(
      name: "with string",
      input: CHAT_RESPONSE,
      model: "mistral-small-2503"
    ),
  ]

  cases.each do |tc|
    it "chat request - #{tc.name}" do
      WebMock.stub(:post, "#{url}/v1/chat/completions")
        .with(headers: headers)
        .to_return(
          status: 200,
          body: CHAT_RESPONSE
        )

      client = CrystalMistral::Client.new api_key

      response = client.chat(
        model: "mistral-small-2503",
        messages: tc.input,
        temperature: 1.1_f32
      )

      response.to_json.should contain("id")
      response.to_json.should contain("object")
      response.to_json.should contain("created")
      response.to_json.should contain("model")
      response.to_json.should contain("choices")
      response.to_json.should contain("usage")
      response.to_json.should contain("index")
      response.to_json.should contain("message")
    end
  end

  it "code completation" do
    WebMock.stub(:post, "#{url}/v1/fim/completions")
      .with(headers: headers)
      .to_return(
        status: 200,
        body: CHAT_RESPONSE
      )

    client = CrystalMistral::Client.new api_key

    response = client.code(
      model: "codestral-2501",
      prompt: "func (c *SomeStruct) addUser(name: string, surname: string)",
      suffix: "golang",
      temperature: 1
    )

    response.to_json.should contain("id")
    response.to_json.should contain("object")
    response.to_json.should contain("created")
    response.to_json.should contain("model")
    response.to_json.should contain("choices")
    response.to_json.should contain("usage")
    response.to_json.should contain("index")
    response.to_json.should contain("message")
  end
end
