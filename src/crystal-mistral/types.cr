require "json"

# Possible roles in a conversation message
enum Role
  @[JSON::Field(name: "user")]
  User

  @[JSON::Field(name: "assistant")]
  Assistant

  @[JSON::Field(name: "system")]
  System

  @[JSON::Field(name: "tool")]
  Tool
end

# Represents a single message in the chat input payload
struct Messages
  include JSON::Serializable

  property role : String | Role
  property content : String

  def initialize(@role, @content)
  end
end

struct ChatRequest
  include JSON::Serializable

  property model : String
  property temperature : Float32
  property messages : Array(Messages)

  def initialize(@model, @temperature, @messages)
  end
end

struct Message
  include JSON::Serializable

  property role : String
  property content : String
  property tool_calls : String?
end

struct Choice
  include JSON::Serializable

  property index : Int32
  property message : Message
  property finish_reason : String
end

struct Usage
  include JSON::Serializable

  property prompt_tokens : Int32
  property completion_tokens : Int32
  property total_tokens : Int32
end

struct ChatResponse
  include JSON::Serializable

  property id : String
  property object : String
  property created : Int64
  property model : String
  property choices : Array(Choice)
  property usage : Usage
end

struct EmbeddingRequest
  include JSON::Serializable

  property model : String
  property input : Array(String)

  def initialize(@model, @input)
  end
end

struct EmbeddingObject
  include JSON::Serializable

  property object : String
  property embedding : Array(Float64)
  property index : Int32
end

struct UsageInfo
  include JSON::Serializable

  property prompt_tokens : Int32
  property total_tokens : Int32
end

struct EmbeddingResponse
  include JSON::Serializable

  property id : String
  property object : String
  property data : Array(EmbeddingObject)
  property model : String
  property usage : UsageInfo
end
