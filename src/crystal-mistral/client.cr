require "http/client"
require "./client_builder.cr"
require "./types.cr"
require "./error_types.cr"
require "./methods/chat.cr"
require "./methods/fim.cr"
require "./methods/embeddings.cr"
require "./methods/classifiers.cr"
require "./methods/files.cr"

class CrystalMistral::Client < CrystalMistral::ClientBuilder
  include CrystalMistral::Methods::Chat
  include CrystalMistral::Methods::FIM
  include CrystalMistral::Methods::Embeddings
  include CrystalMistral::Methods::Classifiers
  include CrystalMistral::Methods::Files

  property api_key : String?

  @mistral = "https://api.mistral.ai"

  def initialize(api_key : String? = nil)
    @api_key = api_key.presence || ENV["MISTRAL_API_KEY"]?.presence

    if @api_key.nil?
      raise ArgumentError.new "API key must be provided either as an argument or via MISTRAL_API_KEY environment variable"
    end
  end

  protected def headers
    HTTP::Headers{
      "Authorization" => "Bearer #{api_key}",
      "Content-Type"  => "application/json",
      "Accept"        => "application/json",
    }
  end

  protected def handle_error(response)
    case response.status.code
    when 400
      error = APIError.from_json response.body
      raise "#{response.status}: #{response.status.code}, message: #{error.message}, code: #{error.code}"
    when 401
      raise "#{response.status.code} - #{response.status}: #{response.body}"
    when 404
      raise "#{response.status.code} - #{response.status}: #{response.body}"
    when 422
      error = ValidationError.from_json response.body
      raise "#{response.status}: #{response.status.code}, message: #{error.message.detail[0].msg}"
    else
      raise "Unexpected status #{response.status.code}: #{response.body}"
    end
  end
end
