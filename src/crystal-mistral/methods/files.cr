require "../types.cr"
require "../error_types.cr"
require "../client_builder.cr"
require "http"

module CrystalMistral::Methods::Files
  def upload_file(file_path : String, purpose : FilePurpose) : UploadFileResponse
    raise ArgumentError.new("file_path must not be empty") if file_path.strip.empty?

    with_http_client @mistral do |client|
      IO.pipe do |reader, writer|
        channel = Channel(String).new(1)

        spawn do
          HTTP::FormData.build(writer) do |formdata|
            channel.send(formdata.content_type)

            formdata.field("purpose", purpose.to_s)

            File.open(file_path) do |file|
              metadata = HTTP::FormData::FileMetadata.new(filename: File.basename(file_path))
              headers = HTTP::Headers{"Content-Type" => "application/octet-stream"}
              formdata.file("file", file, metadata, headers)
            end
          end
          writer.close
        end

        content_type = channel.receive

        file_headers = HTTP::Headers.new
        file_headers.merge! headers
        file_headers["Content-Type"] = content_type

        response = client.post(path: "/v1/files", headers: file_headers, body: reader)
        return UploadFileResponse.from_json response.body if response.status.success?

        handle_error response
      end
    end
  end

  def delete_file(file_id : String)
    raise ArgumentError.new("file_id must not be empty") if file_id.strip.empty?

    with_http_client @mistral do |client|
      response = client.delete(path: "/v1/files/#{file_id}", headers: headers)
      return response.body if response.status.success?
      handle_error response
    end
  end
end
