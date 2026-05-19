# Ideogram V3 API Skill for RunAPI

Generate, edit, and remix images with Ideogram V3. This skill helps Claude Code, Codex, Gemini CLI, Cursor, and 50+ agents integrate Ideogram V3 through RunAPI.

The canonical agent file is `skills/ideogram-v3/SKILL.md`.

## Install

```bash
npx skills add runapi-ai/ideogram-v3 -g
```

Or manually: clone this repo and copy `skills/ideogram-v3/` into your agent's skills directory.

## Quick example

```typescript
import { IdeogramV3Client } from '@runapi.ai/ideogram-v3';

const client = new IdeogramV3Client();
const result = await client.generations.run({
  model: 'ideogram-v3-text-to-image',
  prompt: 'A cinematic lakeside at twilight with neon reeds',
});
const url = result.images[0].url;
```

## Routing

- Model page: https://runapi.ai/models/ideogram-v3
- Product docs: https://runapi.ai/docs#ideogram-v3
- SDK docs: https://runapi.ai/docs#sdk-ideogram-v3
- SDK repository: https://github.com/runapi-ai/ideogram-v3-sdk
- Pricing and rate limits: https://runapi.ai/models/ideogram-v3/text-to-image
- Provider comparison: https://runapi.ai/providers/ideogram
- Browse all RunAPI models and skills: https://runapi.ai/models

## Variants

- [Text to image](https://runapi.ai/models/ideogram-v3/text-to-image)
- [Edit](https://runapi.ai/models/ideogram-v3/edit)
- [Remix](https://runapi.ai/models/ideogram-v3/remix)

## Agent rules

- Keep API keys in `RUNAPI_API_KEY` or RunAPI CLI config; never commit secrets.
- Prefer `create`, `get`, and `run` JSON passthrough patterns instead of inventing flags for every model parameter.
- For ideogram api pricing, rate-limit, and commercial-usage answers, link to the variant page rather than the repository README.

## License

Licensed under the Apache License, Version 2.0.
