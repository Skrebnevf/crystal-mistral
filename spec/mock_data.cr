CHAT_RESPONSE              = %({"id":"b5fcb244d8304a9f89765abf357031a4","object":"chat.completion","created":1750957661,"model":"mistral-small-2503","choices":[{"index":0,"message":{"role":"assistant","content":"It looks like you're excited to know the time! I don't have real-time capabilities, but you can easily find the current time by checking your device's clock or performing a quick internet search. If you're in a specific time zone and want to know the time there, let me know, and I can help you figure it out!"},"finish_reason":"stop"}],"usage":{"prompt_tokens":12,"completion_tokens":70,"total_tokens":82}})
CODE_COMPLETATION_RESPONSE = %({"id":"814608aa6bf04d349fc8f87f45791a96","object":"chat.completion","created":1750960722,"model":"codestral-2501","choices":[{"index":0,"message":{"role":"assistant","content":" {tc.Users = append(c.Users, User{name: name, surname: surname}) func (c *SomeStruct) addUser(name: string, surname: string) {tc.Users = append(c.Users, User{name: name, surname: surname})} "},"finish_reason":"stop"}],"usage":{"prompt_tokens":23,"completion_tokens":57,"total_tokens":80}})
STRING_MESSAGE             = %([{"role": "user", "content": "WHAT TIME IS IT?!"}])
EMBENDDINGS_RESPONSE       = %({"id":"1c499a218a584a11aeedabf3123c2bf4","object":"list","data":[{"object":"embedding","embedding":[-0.0216217041015625,0.0194854736328125],"index":1}],"model":"mistral-embed","usage":{"prompt_tokens":6,"total_tokens":6}})
MODERATION_RESPONSE        = %({"id":"bda4b52e0efe466792f03ad665b9a328","usage":{"prompt_tokens":7,"completion_tokens":0,"total_tokens":96},"model":"mistral-moderation-2411","results":[{"category_scores":{"sexual":0.00021654405281879008,"hate_and_discrimination":6.205049430718645e-5,"violence_and_threats":0.0006667023408226669,"dangerous_and_criminal_content":0.001098731067031622,"selfharm":2.93115390377352e-5,"health":8.481103577651083e-5,"financial":1.4738982827111613e-5,"law":2.1444948288262822e-5,"pii":0.0006070755189284682},"categories":{"sexual":false,"hate_and_discrimination":false,"violence_and_threats":false,"dangerous_and_criminal_content":false,"selfharm":false,"health":false,"financial":false,"law":false,"pii":false}}]})
ERROR_400_RESPONSE         = %({"object":"error","message":"Invalid model: mistral-small-250","type":"invalid_model","code":"1500"})
ERROR_422_RESPONSE         = %({"object":"error","message":{"detail":[{"loc":["body","temperature"],"msg":"Input should be less than or equal to 1.5","type":"less_than_equal"}]},"type":"invalid_request_error"})
DIALOG_MESSAGE             = [
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
