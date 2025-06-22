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
messages = [
  Messages.new(role: Role::User, content: "Hello!")
]

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

## ✔️ TODO

- [x] Add Chat Completion
- [x] Add Embeddings
- [ ] Add Tests
- [x] Add FIM
- [ ] Add Agents
- [ ] Add Classifiers
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
