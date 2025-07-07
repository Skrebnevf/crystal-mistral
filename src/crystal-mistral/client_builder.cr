require "http/client"
require "uri"

# Abstract base class for Mistral client implementations.
#
# Provides a protected helper method `with_http_client` for performing
# HTTP requests with configurable timeouts and error handling.
abstract class CrystalMistral::ClientBuilder
  # This method is meant to be used by subclasses such as `CrystalMistral::Client`.
  #
  # Arguments:
  # - url : String — full URL string to connect to (must include scheme like "https")
  # - connet_timeout : Time::Span = 120.seconds — optional connection timeout
  #
  # Yields:
  # - An instance of `HTTP::Client` for executing requests
  #
  # Raises:
  # - `"Timeout error: ..."` on `IO::TimeoutError`
  # - `"Network error: ..."` on `IO::Error`
  # - `"Exception error: ..."` on any other unhandled exception
  protected def with_http_client(
    url : String,
    connect_timeout : Time::Span = 120.seconds,
    &
  )
    uri = URI.parse url

    HTTP::Client.new uri do |client|
      client.connect_timeout = connect_timeout

      begin
        yield client
      rescue ex : IO::TimeoutError
        raise "Timeout error: #{ex.message}"
      rescue ex : IO::Error
        raise "Network error: #{ex.message}"
      rescue ex : Exception
        raise "Exception error: #{ex.message}"
      end
    end
  end
end
