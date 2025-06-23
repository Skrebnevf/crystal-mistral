require "../types.cr"
require "../error_types.cr"
require "../client_builder.cr"

module CrystalMistral::Methods::Classifiers
  # Sends a moderation request to the Mistral.
  #
  # This method checks the input text against moderation classifiers
  # to determine whether the content violates usage policies.
  #
  # Arguments:
  # - model : String — the name of the moderation model to use (e.g., "mistral-moderation-latest")
  # - input : String — the text to moderate
  #
  # Returns:
  # - ModerationResponse — the parsed moderation result from the API
  #
  # Raises:
  # - ArgumentError if either `model` or `input` is empty
  # - RuntimeError if API returns bad request code or unexpected error
  #
  # Example:
  # ```
  # response = client.moderation(
  #   model: "mistral-moderation-latest",
  #   input: "I hate you and want to hurt people"
  # )
  #
  # puts "Content: #{response.results[0].categories}"
  # ```
  def moderation(model : String, input : String) : ModerationResponse
    if model.strip.empty? || input.strip.empty?
      raise ArgumentError.new "model and/or input must not be empty"
    end

    payload = ClassifiersRequest.new(
      model: model,
      input: input,
    ).to_json

    with_http_client @mistral do |client|
      response = client.post(path: "/v1/moderations", headers: headers, body: payload)

      case response.status.code
      when 200
        ModerationResponse.from_json response.body
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

  # Sends a moderation request for a chat conversation to the Mistral API.
  #
  # Accepts either a JSON string or an array of chat messages (`Messages`) representing the conversation,
  # and returns a `ModerationResponse` with flagged content and category breakdowns.
  #
  # Arguments:
  # - model : String — the name of the moderation model to use (e.g., "mistral-moderation-latest")
  # - input : Array(Messages) | String — the conversation history either as a parsed array or a JSON string
  #
  # Returns:
  # - ModerationResponse — the parsed moderation result for the chat conversation
  #
  # Raises:
  # - ArgumentError if either `model` or `input` is empty
  # - RuntimeError if API returns bad request code or unexpected error
  #
  # Example:
  # ```
  # # Use custom Messages type
  # messages = [
  #   Messages.new(role: "user", content: "I want to hate someone."),
  #   Messages.new(role: "assistant", content: "That doesn't sound good."),
  # ]
  #
  # # or String
  # messages = %([{"role": "user", "content": "I want to hate someone."}])
  #
  # response = client.chat_moderations(
  #   model: "mistral-moderation-latest",
  #   input: messages
  # )
  #
  # puts "Content: #{response.results[0].categories}"
  # ```
  def chat_moderations(model : String, input : Array(Messages) | String)
    raise ArgumentError.new "model and/or input must not be empty" if model.strip.empty?

    parsed_input = case input
                   when String
                     Array(Messages).from_json(input)
                   when Array(Messages)
                     input
                   else
                     raise ArgumentError.new "Unsupported type for input"
                   end

    payload = ClassifiersChatRequest.new(
      model: model,
      input: parsed_input,
    ).to_json

    with_http_client @mistral do |client|
      response = client.post(path: "/v1/chat/moderations", headers: headers, body: payload)

      case response.status.code
      when 200
        ModerationResponse.from_json response.body
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
