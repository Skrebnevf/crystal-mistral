require "./spec_helper"
require "../src/crystal-mistral/client"
require "webmock"
require "./mock_data.cr"

url = "https://api.mistral.ai"
api_key = "test-key"

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
      input: STRING_MESSAGE,
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
        model: tc.model,
        messages: tc.input,
        temperature: 1.1_f32
      )

      json = response.to_json
      %w(id object created model choices usage index message).each do |key|
        json.should contain key
      end
    end
  end

  it "code completation" do
    WebMock.stub(:post, "#{url}/v1/fim/completions")
      .with(headers: headers)
      .to_return(
        status: 200,
        body: CODE_COMPLETATION_RESPONSE
      )

    client = CrystalMistral::Client.new api_key

    response = client.code(
      model: "codestral-2501",
      prompt: "func (c *SomeStruct) addUser(name: string, surname: string)",
      suffix: "golang",
      temperature: 1
    )

    json = response.to_json
    %w(id object created model choices usage index message).each do |key|
      json.should contain key
    end
  end

  it "embenddings" do
    WebMock.stub(:post, "#{url}/v1/embeddings")
      .with(headers: headers)
      .to_return(
        status: 200,
        body: EMBENDDINGS_RESPONSE
      )

    client = CrystalMistral::Client.new api_key

    input = ["C", "M"]

    response = client.embeddings(
      model: "mistral-embed",
      input: input
    )

    json = response.to_json
    %w(id object model data usage).each do |key|
      json.should contain key
    end
  end

  it "moderation" do
    WebMock.stub(:post, "#{url}/v1/moderations")
      .with(headers: headers)
      .to_return(
        status: 200,
        body: MODERATION_RESPONSE
      )

    client = CrystalMistral::Client.new api_key

    response = client.moderation(
      model: "mistral-moderation-2411",
      input: "I hate you!"
    )

    json = response.to_json
    %w(id usage model result).each do |key|
      json.should contain key
    end
  end

  cases = [
    TestCase.new(
      name: "with dialog",
      input: DIALOG_MESSAGE,
      model: "mistral-moderation-2411"
    ),
    TestCase.new(
      name: "with string",
      input: STRING_MESSAGE,
      model: "mistral-moderation-2411"
    ),
  ]

  cases.each do |tc|
    it "chat moderation - #{tc.name}" do
      WebMock.stub(:post, "#{url}/v1/chat/moderations")
        .with(headers: headers)
        .to_return(
          status: 200,
          body: MODERATION_RESPONSE
        )

      client = CrystalMistral::Client.new api_key

      response = client.chat_moderations(
        model: tc.model,
        input: tc.input
      )

      json = response.to_json
      %w(id usage model result).each do |key|
        json.should contain key
      end
    end
  end

  # it "upload file" do
  #   WebMock.stub(:post, "#{url}/v1/files")
  #     .with(headers: headers)
  #     .to_return(
  #       status: 200,
  #       body: MODERATION_RESPONSE
  #     )

  #   client = CrystalMistral::Client.new api_key

  #   client.upload_file(file_path: "", purpose: FilePurpose::Batch)
  # end
end
