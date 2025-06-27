# ⚡ Crystal Mistral Client

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     crystal-mistral:
       github: Skrebnevf/crystal-mistral
   ```

2. Run `shards install`

## 🖥️ Usage

```crystal
require "crystal-mistral"

# API key can be passed directly or loaded from ENV["MISTRAL_API_KEY"]
client = CrystalMistral::Client.new
```

## 💬 Chat Completion

```crystal
# Use custom Messages type
messages = [
  Messages.new(role: Role::User, content: "Hello!")
]
# or String type
messages = %([{"role": "user", "content": "Best place in Norilsk"}])
# if you just pass the string
# messages = “AAA WHAT TIME IS IT?!”
# string convert to -> [Messages.new(role: "user", content: messages)]
response = client.chat(
  model: "mistral-large-latest",
  messages: messages,
  temperature: 0.7_f32
)

puts response.choices[0].message.content
```

## 💻 Code Completion

```crystal
 client = CrystalMistral::Client.new

  response = client.code(
    model: "codestral-2405",
    prompt: "def hello(name : String)",
    suffix: "",
    temperature: 0.7
  )

  puts "Generated code:\n#{puts resp.choices[0].message.content}"
```

## 🧠 Embeddings

```crystal
texts = ["Let's compare London and Paris", "Compare?!"]

response = client.embeddings(
  model: "mistral-embed",
  input: texts
)

response.data.each_with_index do |embedding, idx|
  puts "Embedding ##{idx}: #{embedding.embedding[0..4]}"
end
```

## 📊 Classifiers

```crystal
# Moderation
response = client.moderation(
  model: "mistral-moderation-latest",
  input: "I hate you and want to hurt people"
)

puts "Content: #{response.results[0].categories}"

# Chat moderation
# Use custom Messages type
messages = [
  Messages.new(role: "user", content: "I want to hate someone."),
  Messages.new(role: "assistant", content: "That doesn't sound good."),
]
# or String
messages = %([{"role": "user", "content": "I want to hate someone."}])

response = client.chat_moderations(
  model: "mistral-moderation-latest",
  input: messages
)

puts "Content: #{response.results[0].categories}"

# Classification
# if you just pass the string
# messages = “AAA WHAT TIME IS IT?!”
# string convert to -> [Messages.new(role: "user", content: messages)]
# Note: It is not clear what classification model Mistral AI is offering
response = client.classification(
  model: "mistral-classification-model",
  input: "This document discusses violent actions."
)

puts response

# Classification Chat
# if you just pass the string
# messages = “AAA WHAT TIME IS IT?!”
# string convert to -> [Messages.new(role: "user", content: messages)]
# Note: It is not clear what classification model Mistral AI is offering
messages = [
  Messages.new(role: "user", content: "I hate everything."),
  Messages.new(role: "assistant", content: "Let's keep things peaceful."),
]

response = client.classification_chat(
  model: "mistral-classification-model",
  input: messages
)

puts response
```

## ✔️ TODO

- [x] Add Chat Completion
- [x] Add Embeddings
- [x] Add Tests
- [x] Add FIM
- [ ] Add Agents
- [x] Add Classifiers
- [ ] Add Files
- [ ] Add Fine Tuning

## 🤝 Contributing

1. Fork it (<https://github.com/Skrebnevf/crystal-mistral/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## 🏠 Contributors

- [f.skrebnev](https://github.com/Skrebnevf) - creator and maintainer
- [@hope_you_die](https://t.me/hope_you_die) - TG
