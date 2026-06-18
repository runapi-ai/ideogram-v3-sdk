# Ideogram API Go SDK for RunAPI

The ideogram api Go SDK is the language-specific package for Ideogram V3 on RunAPI. Use this ideogram api package for text-to-image, character reference generation, edit, remix, reframe, and creative production flows when your application needs JSON request bodies, task status lookup, and consistent RunAPI errors in Go.

This ideogram api README is the Go package guide inside the public `ideogram-v3-sdk` repository. For the repository overview, start at `../README.md`; for model details, use https://runapi.ai/models/ideogram-v3; for API reference, use https://runapi.ai/docs#ideogram-v3; for SDK docs, use https://runapi.ai/docs#sdk-ideogram-v3.

## Install

```bash
go get github.com/runapi-ai/ideogram-v3-sdk/go@latest
```

## Quick start

```go
import (
  "context"

  "github.com/runapi-ai/ideogram-v3-sdk/go/ideogramv3"
)

client, err := ideogramv3.NewClient()
task, err := client.TextToImage.Create(context.Background(), ideogramv3.TextToImageParams{
  Model:  ideogramv3.ModelTextToImage,
  Prompt: "A cinematic lakeside at twilight with neon reeds",
})
status, err := client.TextToImage.Get(context.Background(), task.ID)
```

Use `create` when you want to submit a task and return quickly, `get` when you need the latest task state, and `run` when a script should create and poll until completion. In web request handlers, prefer `create` plus webhook or later `get` polling so a worker is not held open.

RunAPI-generated file URLs are temporary. Download and store generated images, videos, audio, or other files in your own durable storage within 7 days; do not treat returned URLs as long-term assets.

## Language notes

Use the public Go module with `github.com/runapi-ai/core-sdk/go` options when building image services, CLIs, or workers. The available resources are `TextToImage`, `EditImage`, `RemixImage`, and `ReframeImage`. Keep `RUNAPI_API_KEY` in the environment or your secret manager; never commit API keys or callback secrets.

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
