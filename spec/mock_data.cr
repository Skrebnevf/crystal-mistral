CHAT_RESPONSE  = %({"id":"b5fcb244d8304a9f89765abf357031a4","object":"chat.completion","created":1750957661,"model":"mistral-small-2503","choices":[{"index":0,"message":{"role":"assistant","content":"It looks like you're excited to know the time! I don't have real-time capabilities, but you can easily find the current time by checking your device's clock or performing a quick internet search. If you're in a specific time zone and want to know the time there, let me know, and I can help you figure it out!"},"finish_reason":"stop"}],"usage":{"prompt_tokens":12,"completion_tokens":70,"total_tokens":82}})
STRING_MESSAGE = %([{"role": "user", "content": "WHAT TIME IS IT?!"}])

DIALOG_MESSAGE = [
  Messages.new(
    role: Role::User,
    content: "Hi"
  ),
  Messages.new(
    role: Role::Assistant,
    content: "Hi!"
  ),
  Messages.new(
    role: Role::User,
    content: "What time is it?"
  ),
  Messages.new(
    role: Role::Assistant,
    content: "Sorry? You location is?"
  ),
  Messages.new(
    role: Role::User,
    content: "WHAT TIME IS IT!"
  ),
]

CODE_COMPLETATION = %({"id":"83f8cf06c868465ab13a33339da87cd7","object":"chat.completion","created":1750960635,"model":"codestral-2501","choices":[{"index":0,"message":{"role":"assistant","content":" {\n\tc.Name = name\n\tc.Surname = surname\n}\n\nfunc (c *SomeStruct) getUser() (string, string) {\n\treturn c.Name, c.Surname\n}\n\nfunc (c *SomeStruct) getUserName() string {\n\treturn c.Name\n}\n\nfunc (c *SomeStruct) getUserSurname() string {\n\treturn c.Surname\n}\n\n// "},"finish_reason":"stop"}],"usage":{"prompt_tokens":23,"completion_tokens":78,"total_tokens":101}})
