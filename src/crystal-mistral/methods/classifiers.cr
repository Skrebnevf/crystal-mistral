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
  # - RuntimeError via `handle_error` if the response indicates an error
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
      return ModerationResponse.from_json response.body if response.status.success?
      handle_error(response)
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
  # - RuntimeError via `handle_error` if the response indicates an error
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
  # # if you just pass the string
  # messages = “AAA WHAT TIME IS IT?!”
  # # string convert to -> [Messages.new(role: "user", content: messages)]
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
                   when Array(Messages)
                     input
                   when String
                     begin
                       Array(Messages).from_json(input)
                     rescue ex : JSON::ParseException
                       [Messages.new(role: "user", content: input)]
                     end
                   else
                     raise ArgumentError.new("Unsupported input type")
                   end

    payload = ClassifiersChatRequest.new(
      model: model,
      input: parsed_input,
    ).to_json

    with_http_client @mistral do |client|
      response = client.post(path: "/v1/chat/moderations", headers: headers, body: payload)
      return ModerationResponse.from_json response.body if response.status.success?
      handle_error response
    end
  end

  # Sends a classification request to the Mistral API (/v1/classifications).
  #
  # This method takes a plain input string and sends it to the classification endpoint
  # using the specified model. It returns the raw response body as a string, which can
  # be further parsed depending on the expected response structure.
  #
  # Arguments:
  # - model : String — the name of the classification model to use (e.g., "mistral-classification-latest")
  # - input : String — the text to classify
  #
  # Returns:
  # - String — raw JSON response body from the API
  #
  # Raises:
  # - ArgumentError if `model` or `input` is empty
  # - RuntimeError via `handle_error` if the response indicates an error
  #
  # Example:
  # ```
  # response_json = client.classification(
  #   model: "mistral-classification-latest",
  #   input: "This document discusses violent actions."
  # )
  #
  # puts response_json
  # ```
  # TODO: learn how the classifier works properly and create types
  def classification(model : String, input : String) : String
    if model.strip.empty? || input.strip.empty?
      raise ArgumentError.new "model and/or input must not be empty"
    end

    payload = ClassifiersRequest.new(
      model: model,
      input: input
    ).to_json

    with_http_client @mistral do |client|
      response = client.post(path: "/v1/classifications", headers: headers, body: payload)
      return response.body if response.status.success?
      handle_error response
    end
  end

  # Sends a classification request for a chat conversation to the Mistral API (/v1/chat/classifications).
  #
  # This method accepts either:
  # - an array of chat messages (`Array(Messages)`), or
  # - a JSON string (representing an array of messages), or
  # - a plain string (treated as a single user message)
  #
  # The input is normalized to a list of `Messages`, wrapped in a `ClassifiersChatRequest`,
  # and sent to the API. Returns the raw JSON response from the server.
  #
  # Arguments:
  # - model : String — the name of the classification model (e.g., "mistral-chat-classification-latest")
  # - input : Array(Messages) | String — conversation history as array or JSON or plain string
  #
  # Returns:
  # - String — raw JSON response body from the API
  #
  # Raises:
  # - ArgumentError if model is empty or input type is unsupported
  # - RuntimeError via `handle_error` if the response status is an error
  #
  # ```
  # messages = [
  #   Messages.new(role: "user", content: "I hate everything."),
  #   Messages.new(role: "assistant", content: "Let's keep things peaceful."),
  # ]
  # # if you just pass the string
  # messages = “AAA WHAT TIME IS IT?!”
  # # string convert to -> [Messages.new(role: "user", content: messages)]
  #
  # response = client.classification_chat(
  #   model: "mistral-chat-classification-latest",
  #   input: messages
  # )
  #
  # puts response
  # ```
  # TODO: learn how the classifier works properly and create types
  def classification_chat(model : String, input : Array(Messages) | String) : String
    raise ArgumentError.new model if model.strip.empty?

    parsed_input = case input
                   when Array(Messages)
                     input
                   when String
                     begin
                       Array(Messages).from_json(input)
                     rescue ex : JSON::ParseException
                       [Messages.new(role: "user", content: input)]
                     end
                   else
                     raise ArgumentError.new("Unsupported input type")
                   end

    payload = ClassifiersChatRequest.new(
      model: model,
      input: parsed_input
    ).to_json

    with_http_client @mistral do |client|
      response = client.post(path: "/v1/chat/classifications", headers: headers, body: payload)
      return response.body if response.status.success?
      handle_error response
    end
  end
end
