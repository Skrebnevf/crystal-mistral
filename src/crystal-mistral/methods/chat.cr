require "../types.cr"
require "../error_types.cr"
require "../client_builder.cr"
require "http/client"

module CrystalMistral::Methods::Chat
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
  # # Use custom Messages type
  # messages = [
  #   Messages.new(
  #     role: Role::User,
  #     content: "Hello, Mistral!"
  #   ),
  # ]
  #
  # # or String type
  # messages = %([{"role": "user", "content": "Best place in Norilsk"}])
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
    messages : Array(Messages) | String,
    temperature : Float32 = 1,
  ) : ChatResponse
    raise ArgumentError.new "model must not be empty" if model.strip.empty?

    parsed_messages = case messages
                      when String
                        Array(Messages).from_json(messages)
                      when Array(Messages)
                        messages
                      else
                        raise ArgumentError.new "Unsupported type for messages"
                      end

    payload = ChatRequest.new(
      model: model,
      temperature: temperature,
      messages: parsed_messages
    ).to_json

    with_http_client @mistral do |client|
      response = client.post(path: "/v1/chat/completions", headers: headers, body: payload)
      return ChatResponse.from_json response.body if response.status.success?
      handle_error response
    end
  end
end
