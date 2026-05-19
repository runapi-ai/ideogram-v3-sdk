# Ideogram API Ruby SDK for RunAPI

The ideogram api Ruby SDK is the language-specific package for Ideogram V3 on RunAPI. Use this ideogram api package for text-to-image, image-to-image, edit, and creative production flows when your application needs JSON request bodies, task status lookup, and consistent RunAPI errors in Ruby.

This ideogram api README is the Ruby package guide inside the public `ideogram-v3-sdk` repository. For the repository overview, start at `../README.md`; for model details, use https://runapi.ai/models/ideogram-v3; for API reference, use https://runapi.ai/docs#ideogram-v3; for SDK docs, use https://runapi.ai/docs#sdk-ideogram-v3.

## Install

```bash
gem install runapi-ideogram-v3
```

## Quick start

```ruby
require "runapi-ideogram-v3"

client = RunApi::IdeogramV3::Client.new
task = client.generations.create(
  # Pass the Ideogram V3 JSON request body from https://runapi.ai/docs#ideogram-v3.
)
status = client.generations.get(task.id)
```

Use `create` when you want to submit a task and return quickly, `get` when you need the latest task state, and `run` when a script should create and poll until completion. In web request handlers, prefer `create` plus webhook or later `get` polling so a worker is not held open.

## Language notes

Use Ruby keyword arguments and the `RunApi::IdeogramV3` error classes when building image jobs, Rails workers, or scripts. The available resources include generations, edits, and remixes. Keep `RUNAPI_API_KEY` in the environment or your secret manager; never commit API keys or callback secrets.

## Links

- Model page: https://runapi.ai/models/ideogram-v3
- SDK docs: https://runapi.ai/docs#sdk-ideogram-v3
- Product docs: https://runapi.ai/docs#ideogram-v3
- Pricing and rate limits: https://runapi.ai/models/ideogram-v3/text-to-image
- Provider comparison: https://runapi.ai/providers/ideogram
- Full catalog: https://runapi.ai/models
- Repository: https://github.com/runapi-ai/ideogram-v3-sdk

## License

Licensed under the Apache License, Version 2.0.
