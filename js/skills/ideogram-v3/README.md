<p align="center">
  <a href="https://github.com/runapi-ai/ideogram-v3">
    <h3 align="center">Ideogram V3 API Skill for RunAPI</h3>
  </a>
</p>

<p align="center">
  Install this agent skill, inspect Ideogram V3 fields, then run jobs through the RunAPI CLI.
</p>

<p align="center">
  <a href="https://runapi.ai/models/ideogram-v3"><strong>Model Reference</strong></a> · <a href="https://github.com/runapi-ai/cli"><strong>CLI</strong></a> · <a href="https://github.com/runapi-ai/ideogram-v3-sdk"><strong>SDK</strong></a>
</p>

<div align="center">

[![skills.sh](https://www.skills.sh/b/runapi-ai/ideogram-v3)](https://www.skills.sh/runapi-ai/ideogram-v3/ideogram-v3)
[![ClawHub](https://img.shields.io/badge/ClawHub-runapi--ideogram--v3-111827)](https://clawhub.ai/runapi-ai/runapi-ideogram-v3)
[![License](https://img.shields.io/github/license/runapi-ai/ideogram-v3)](https://github.com/runapi-ai/ideogram-v3/blob/main/LICENSE)

</div>
<br/>

Generate, edit, remix, and reframe images with Ideogram V3. This skill helps Claude Code, Codex, Gemini CLI, Cursor, and 50+ agents integrate Ideogram V3 through RunAPI.

The canonical agent file is `skills/ideogram-v3/SKILL.md`.

## Install

```bash
npx skills add runapi-ai/ideogram-v3 -g
```

Or paste this prompt to your AI agent:

```text
Install the ideogram-v3 skill for me:

1. Clone https://github.com/runapi-ai/ideogram-v3
2. Copy the skills/ideogram-v3/ directory into your
   user-level skills directory (e.g. ~/.claude/skills/
   for Claude Code, ~/.codex/skills/ for Codex).
3. Verify that SKILL.md is present.
4. Confirm the install path when done.
```

## Quick example

```typescript
import { IdeogramV3Client } from '@runapi.ai/ideogram-v3';

const client = new IdeogramV3Client();
const result = await client.textToImage.run({
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
- [Character](https://runapi.ai/models/ideogram-v3/character)
- [Character edit](https://runapi.ai/models/ideogram-v3/character-edit)
- [Character remix](https://runapi.ai/models/ideogram-v3/character-remix)
- [Reframe](https://runapi.ai/models/ideogram-v3/reframe)

## Agent rules

- Keep API keys in `RUNAPI_API_KEY` or RunAPI CLI config; never commit secrets.
- Prefer `create`, `get`, and `run` JSON passthrough patterns instead of inventing flags for every model parameter.
- For ideogram api pricing, rate-limit, and commercial-usage answers, link to the variant page rather than the repository README.

## License

Licensed under the Apache License, Version 2.0.
