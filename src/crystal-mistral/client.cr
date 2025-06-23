require "http/client"
require "./client_builder.cr"
require "./types.cr"
require "./error_types.cr"
require "./methods/chat.cr"
require "./methods/fim.cr"
require "./methods/embeddings.cr"
require "./methods/classifiers.cr"

class CrystalMistral::Client < CrystalMistral::ClientBuilder
  include CrystalMistral::Methods::Chat
  include CrystalMistral::Methods::FIM
  include CrystalMistral::Methods::Embeddings
  include CrystalMistral::Methods::Classifiers

  property api_key : String?

  @mistral = "https://api.mistral.ai"

  def headers
    HTTP::Headers{
      "Authorization" => "Bearer #{api_key}",
      "Content-Type"  => "application/json",
      "Accept"        => "application/json",
    }
  end

  def initialize(api_key : String? = nil)
    @api_key = api_key.presence || ENV["MISTRAL_API_KEY"]?.presence

    if @api_key.nil?
      raise ArgumentError.new "API key must be provided either as an argument or via MISTRAL_API_KEY environment variable"
    end
  end
end
