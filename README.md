# Ideogram API SDK for RunAPI

The ideogram api SDK packages JavaScript, Ruby, and Go clients for Ideogram V3 on RunAPI. Use this ideogram api SDK for text-to-image, inpaint editing, and image remix workflows that need typed installs, JSON request bodies, task polling, and consistent RunAPI errors across services.

Ideogram V3 belongs to the Ideogram catalog on RunAPI. The public model page is https://runapi.ai/models/ideogram-v3; variant pages below carry pricing, rate-limit, and commercial-usage details. The public `ideogram-v3-sdk` repository groups the JavaScript, Ruby, and Go packages for this model.

## Install

```bash
npm install @runapi.ai/ideogram-v3
gem install runapi-ideogram_v3
go get github.com/runapi-ai/ideogram-v3-sdk/go@latest
```

## What you can build

- Build creative tools, agent pipelines, and production integrations with the ideogram api SDK.
- Keep one model-specific repository while installing only the language package your app needs.
- Use `create` for submit-only jobs, `get` for status lookup, and `run` for submit-and-poll scripts.
- Handle authentication, validation, rate limits, insufficient credits, task failures, and polling timeouts through RunAPI SDK errors.

The JavaScript client exposes text to image, edit image, remix image resources, and the Ruby and Go packages mirror the same RunAPI task lifecycle.

## JavaScript quick start

```typescript
import { IdeogramV3Client } from '@runapi.ai/ideogram-v3';

const client = new IdeogramV3Client();

const task = await client.textToImage.create({
  // Pass the Ideogram V3 request body documented at https://runapi.ai/docs#ideogram-v3.
});

const status = await client.textToImage.get(task.id);
```

For short scripts, use `run` with the same JSON body to create the task and wait for completion. For web request handlers, prefer `create` plus webhook or later `get` polling so the server does not hold a worker open.

## Repository layout

- `js/` publishes `@runapi.ai/ideogram-v3`.
- `ruby/` publishes `runapi-ideogram_v3` when RubyGems publishing resumes.
- `go/` publishes `github.com/runapi-ai/ideogram-v3-sdk/go` and depends on `github.com/runapi-ai/core-sdk/go`.

## Public links

- Model page: https://runapi.ai/models/ideogram-v3
- SDK docs: https://runapi.ai/docs#sdk-ideogram-v3
- Product docs: https://runapi.ai/docs#ideogram-v3
- SDK repository: https://github.com/runapi-ai/ideogram-v3-sdk
- Skill repository: https://github.com/runapi-ai/ideogram-v3
- Provider comparison: https://runapi.ai/providers/ideogram
- Full catalog: https://runapi.ai/models

## Pricing and variants

Use the most specific ideogram api variant page for pricing, rate limits, and commercial usage:
- [Text to image](https://runapi.ai/models/ideogram-v3/text-to-image)
- [Edit](https://runapi.ai/models/ideogram-v3/edit)
- [Remix](https://runapi.ai/models/ideogram-v3/remix)

Default pricing link for the ideogram api SDK: https://runapi.ai/models/ideogram-v3/text-to-image

## FAQ

### Which package should I install for ideogram api work?

Install the model package for your language: `@runapi.ai/ideogram-v3`, `runapi-ideogram_v3`, or `github.com/runapi-ai/ideogram-v3-sdk/go`. Install core SDK packages only when you are building shared SDK infrastructure.

### Where should public links point?

Primary ideogram api links point to https://runapi.ai/models/ideogram-v3. Pricing and usage-policy links point to variant pages such as https://runapi.ai/models/ideogram-v3/text-to-image. Provider comparisons point to https://runapi.ai/providers/ideogram, and broad browsing points to https://runapi.ai/models.

## License

Licensed under the Apache License, Version 2.0.
