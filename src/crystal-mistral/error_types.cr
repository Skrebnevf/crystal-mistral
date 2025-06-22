require "json"

struct APIError
  include JSON::Serializable

  property object : String
  property message : String
  property type : String
  property param : String?
  property code : String
end

struct ValidationSubError
  include JSON::Serializable

  property loc : Array(String)
  property msg : String
  property type : String
end

struct ValidationDetails
  include JSON::Serializable

  @[JSON::Field(key: "detail")]
  property detail : Array(ValidationSubError)
end

struct ValidationError
  include JSON::Serializable

  property object : String
  property message : ValidationDetails
  property type : String
  property param : String?
  property code : String?
end
