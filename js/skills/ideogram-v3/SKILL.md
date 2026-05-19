---
name: ideogram-v3
description: Generate, edit, and remix images through RunAPI.ai using the @runapi.ai/ideogram-v3 Node/TypeScript SDK. Use when the user asks to add Ideogram V3 image generation, image editing with masks, remix workflows, or writes against @runapi.ai/ideogram-v3. Triggers on "ideogram", "ideogram-v3", "image generation", "image edit", "@runapi.ai/ideogram-v3".
documentation: https://runapi.ai/models/ideogram-v3
provider_page: https://runapi.ai/providers/ideogram
catalog: https://runapi.ai/models
---
# @runapi.ai/ideogram-v3 - RunAPI.ai Ideogram V3 image generation

Build Node / TypeScript integrations that generate images, edit masked regions, or remix reference images through RunAPI.ai.

## Setup

Requires **Node 18+** (global `fetch`).

```bash
npm install @runapi.ai/ideogram-v3
```

```dotenv
# .env
RUNAPI_API_KEY=runapi_xxx   # get one at https://runapi.ai/settings/api_keys
```

```ts
import { IdeogramV3Client } from '@runapi.ai/ideogram-v3';

const client = new IdeogramV3Client();
```

Pass `{ apiKey }` explicitly if you manage secrets differently. `baseUrl` defaults to `https://runapi.ai`; override only for local development.

## Resources

All resources use the async task contract:

```ts
const { id } = await client.generations.create({ ... });
const status = await client.generations.get(id);
const result = await client.generations.run({ ... });
```

Available resources:

| Resource | Model | Use for |
|---|---|---|
| `client.generations` | `ideogram-v3-text-to-image` | Text-to-image |
| `client.edits` | `ideogram-v3-edit` | Masked image editing |
| `client.remixes` | `ideogram-v3-remix` | Reference image remixing |

## Generate image

```ts
const result = await client.generations.run({
  model: 'ideogram-v3-text-to-image',
  prompt: 'A cinematic lakeside at twilight with neon reeds',
  rendering_speed: 'BALANCED',
  image_size: 'square_hd',
});

const url = result.images[0].url;
```

## Edit image

```ts
const result = await client.edits.run({
  model: 'ideogram-v3-edit',
  prompt: 'Replace the sky with a soft pink sunset',
  image_url: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Example.jpg',
  mask_url: 'https://raw.githubusercontent.com/github/explore/main/topics/python/python.png',
});
```

## Remix image

```ts
const result = await client.remixes.run({
  model: 'ideogram-v3-remix',
  prompt: 'Restyle the image as a clean editorial poster',
  image_url: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Example.jpg',
  rendering_speed: 'TURBO',
  strength: 50,
});
```

## Key params

- `rendering_speed`: `TURBO`, `BALANCED`, or `QUALITY`.
- `style`: `AUTO`, `GENERAL`, `REALISTIC`, or `DESIGN`.
- `image_size`: `square`, `square_hd`, `portrait_4_3`, `portrait_16_9`, `landscape_4_3`, or `landscape_16_9`.
- `num_images`: `1`, `2`, `3`, or `4` for remix.
- `callback_url`: Optional webhook URL for async completion.

## Errors

All errors are re-exported from `@runapi.ai/core`. Use `instanceof` checks instead of string-matching messages. For long-running tasks, prefer `create()` plus webhook or `get(id)` in request handlers, and reserve `run()` for jobs / CLI.

## RunAPI public routing

ideogram api public links use the API-379 catalog route map. The main ideogram api page is https://runapi.ai/models/ideogram-v3. SDK docs live at https://runapi.ai/docs#sdk-ideogram-v3 and product docs live at https://runapi.ai/docs#ideogram-v3.

Pricing, rate limits, and commercial usage for ideogram api should point to the most specific variant page:
- [Text to image](https://runapi.ai/models/ideogram-v3/text-to-image)
- [Edit](https://runapi.ai/models/ideogram-v3/edit)
- [Remix](https://runapi.ai/models/ideogram-v3/remix)

Compare Ideogram V3 with other Ideogram models at https://runapi.ai/providers/ideogram. Browse every RunAPI model and skill at https://runapi.ai/models. SDK repository: https://github.com/runapi-ai/ideogram-v3-sdk. Skill repository: https://github.com/runapi-ai/ideogram-v3.
