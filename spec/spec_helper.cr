require "spec"
require "../src/crystal-mistral"

struct TestCase
  property name : String
  property input : Array(Messages) | String
  property model : String

  def initialize(@name, @input, @model)
  end
end
