require "http/client"
require "./client_builder.cr"
require "./types.cr"
require "./error_types.cr"

class CrystalMistral::Client < CrystalMistral::ClientBuilder
  property api_key : String?

  @mistral = "https://api.mistral.ai"

  def initialize(api_key : String? = nil)
    @api_key = api_key.presence || ENV["MISTRAL_API_KEY"]?.presence

    if @api_key.nil?
      raise ArgumentError.new "API key must be provided either as an argument or via MISTRAL_API_KEY environment variable"
    end
  end

  def headers
    HTTP::Headers{
      "Authorization" => "Bearer #{api_key}",
      "Content-Type"  => "application/json",
      "Accept"        => "application/json",
    }
  end

  # Sends a chat completion request to the Mistral API.
  #
  # Arguments:
  # - model : String — the model name (e.g., "mistral-large-latest")
  # - messages : Array(Messages) — conversation history, each message should have a role and content
  # - temperature : Float32 = 1 — sampling temperature for randomness
  #
  # Returns:
  # - ChatResponse — structured response from Mistral with choices and message content
  #
  # Raises:
  # - ArgumentError if model is empty
  # - RuntimeError with details if the API returns an error
  #
  # Example:
  # ```
  # require "crystal-mistral"
  #
  # messages = [
  #   Message.new(
  #     role: Role::User,
  #     content: "Hello, Mistral!"
  #   ),
  # ]
  #
  # client = CrystalMistral::Client.new
  # response = client.chat(
  #   model: "mistral-large-latest",
  #   messages: messages,
  #   temperature: 0.2_f32
  # )
  # puts response.choices[0].message.content
  # ```
  def chat(
    model : String,
    messages : Array(Messages),
    temperature : Float32 = 1,
  ) : ChatResponse
    raise ArgumentError.new "model must not be empty" if model.strip.empty?

    payload = ChatRequest.new(
      model: model,
      temperature: temperature,
      messages: messages
    ).to_json

    with_http_client @mistral do |client|
      response = client.post(path: "/v1/chat/completions", headers: headers, body: payload)

      case response.status.code
      when 200
        ChatResponse.from_json response.body
      when 400
        error = APIError.from_json response.body
        raise "#{response.status}: #{response.status.code}, message: #{error.message}, code: #{error.code}"
      when 422
        error = ValidationError.from_json response.body
        raise "#{response.status}: #{response.status.code}, message: #{error.message.detail[0].msg}"
      else
        raise "Unexpected status #{response.status.code}: #{response.body}"
      end
    end
  end

  # Sends an embeddings request to the Mistral API.
  #
  # Arguments:
  # - model : String — the model name for embedding (e.g., "mistral-embed")
  # - input : Array(String) — list of texts to be embedded
  #
  # Returns:
  # - EmbeddingResponse — includes vectors for each input
  #
  # Raises:
  # - ArgumentError if model is empty
  # - RuntimeError if API returns bad request code or unexpected error
  #
  # Example:
  # ```
  # input = [
  #   "Crystal is a fast language.",
  #   "Mistral provides language models.",
  # ]
  #
  # client = CrystalMistral::Client.new
  # response = client.embeddings(
  #   model: "mistral-embed",
  #   input: input
  # )
  #
  # response.data.each_with_index do |embedding, i|
  #   puts "Embedding for input ##{i}: #{embedding.embedding[0..4]}..."
  # end
  # ```
  def embeddings(
    model : String,
    input : Array(String),
  ) : EmbeddingResponse
    raise ArgumentError.new "model must not be empty" if model.strip.empty?

    payload = EmbeddingRequest.new(
      model: model,
      input: input,
    ).to_json

    with_http_client @mistral do |client|
      response = client.post(path: "/v1/embeddings", headers: headers, body: payload)

      case response.status.code
      when 200
        EmbeddingResponse.from_json response.body
      when 400
        error = APIError.from_json response.body
        raise "#{response.status}: #{response.status.code}, message: #{error.message}, code: #{error.code}"
      when 422
        error = ValidationError.from_json response.body
        raise "#{response.status}: #{response.status.code}, message: #{error.message.detail[0].msg}"
      else
        raise "Unexpected status #{response.status.code}: #{response.body}"
      end
    end
  end

  # Sends a code completion (FIM - Fill-in-the-Middle) request to the Mistral API.
  #
  # Arguments:
  # - model : String — the model name for code completion (e.g., "codestral-2405")
  # - prompt : String — the prefix (before cursor) code snippet
  # - suffix : String = "" — the suffix (after cursor) code snippet
  # - temperature : Float32 = 1.0 — controls randomness; lower is more deterministic
  #
  # Returns:
  # - ChatResponse — includes the generated code completion
  #
  # Raises:
  # - ArgumentError if model or prompt is empty
  # - RuntimeError if API returns bad request code or unexpected error
  #
  # Example:
  # ```
  # client = CrystalMistral::Client.new
  #
  # response = client.code(
  #   model: "codestral-2405",
  #   prompt: "def hello(name : String)",
  #   suffix: "",
  #   temperature: 0.7
  # )
  #
  # puts "Generated code:\n#{puts resp.choices[0].message.content}"
  # ```
  def code(
    model : String,
    prompt : String,
    suffix : String = "",
    temperature : Float32 = 1,
  ) : ChatResponse
    if model.strip.empty? || prompt.strip.empty?
      raise ArgumentError.new "model and/or prompt must not be empty"
    end

    payload = CodeRequest.new(
      model: model,
      prompt: prompt,
      suffix: suffix,
      temperature: temperature
    ).to_json

    with_http_client @mistral do |client|
      response = client.post(path: "/v1/fim/completions", headers: headers, body: payload)

      case response.status.code
      when 200
        ChatResponse.from_json response.body
      when 400
        error = APIError.from_json response.body
        raise "#{response.status}: #{response.status.code}, message: #{error.message}, code: #{error.code}"
      when 422
        error = ValidationError.from_json response.body
        raise "#{response.status}: #{response.status.code}, message: #{error.message.detail[0].msg}"
      else
        raise "Unexpected status #{response.status.code}: #{response.body}"
      end
    end
  end
end
