CHAT_RESPONSE              = %({"id":"b5fcb244d8304a9f89765abf357031a4","object":"chat.completion","created":1750957661,"model":"mistral-small-2503","choices":[{"index":0,"message":{"role":"assistant","content":"It looks like you're excited to know the time! I don't have real-time capabilities, but you can easily find the current time by checking your device's clock or performing a quick internet search. If you're in a specific time zone and want to know the time there, let me know, and I can help you figure it out!"},"finish_reason":"stop"}],"usage":{"prompt_tokens":12,"completion_tokens":70,"total_tokens":82}})
CODE_COMPLETATION_RESPONSE = %({"id":"814608aa6bf04d349fc8f87f45791a96","object":"chat.completion","created":1750960722,"model":"codestral-2501","choices":[{"index":0,"message":{"role":"assistant","content":" {tc.Users = append(c.Users, User{name: name, surname: surname}) func (c *SomeStruct) addUser(name: string, surname: string) {tc.Users = append(c.Users, User{name: name, surname: surname})} "},"finish_reason":"stop"}],"usage":{"prompt_tokens":23,"completion_tokens":57,"total_tokens":80}})

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
