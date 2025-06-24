require "../types.cr"
require "../error_types.cr"
require "../client_builder.cr"

module CrystalMistral::Methods::FIM
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
  # - RuntimeError via `handle_error` if the response indicates an error
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
      return ChatResponse.from_json response.body if response.status.success?
      handle_error response
    end
  end
end
