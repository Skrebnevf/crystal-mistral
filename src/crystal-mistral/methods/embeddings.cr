require "../types.cr"
require "../error_types.cr"
require "../client_builder.cr"

module CrystalMistral::Methods::Embeddings
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
end
