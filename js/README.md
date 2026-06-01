# Ideogram API JavaScript SDK for RunAPI

The ideogram api JavaScript SDK is the language-specific package for Ideogram V3 on RunAPI. Use this ideogram api package for text-to-image, character reference generation, edit, remix, reframe, and creative production flows when your application needs JSON request bodies, task status lookup, and consistent RunAPI errors in JavaScript.

This ideogram api README is the JavaScript package guide inside the public `ideogram-v3-sdk` repository. For the repository overview, start at `../README.md`; for model details, use https://runapi.ai/models/ideogram-v3; for API reference, use https://runapi.ai/docs#ideogram-v3; for SDK docs, use https://runapi.ai/docs#sdk-ideogram-v3.

## Install

```bash
npm install @runapi.ai/ideogram-v3
```

## Quick start

```typescript
import { IdeogramV3Client } from '@runapi.ai/ideogram-v3';

const client = new IdeogramV3Client();
const task = await client.textToImage.create({
  model: 'ideogram-v3-text-to-image',
  prompt: 'A cinematic lakeside at twilight with neon reeds',
});
const status = await client.textToImage.get(task.id);
```

Use `create` when you want to submit a task and return quickly, `get` when you need the latest task state, and `run` when a script should create and poll until completion. In web request handlers, prefer `create` plus webhook or later `get` polling so a worker is not held open.

## Language notes

Use the TypeScript types in `src/types.ts` and the resource classes under `src/resources` when building image applications. The available resources are `textToImage`, `editImage`, `remixImage`, and `reframeImage`. Keep `RUNAPI_API_KEY` in the environment or your secret manager; never commit API keys or callback secrets.

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
