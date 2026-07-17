# Ideogram V3 API Python SDK for RunAPI

The Ideogram V3 Python SDK is the language-specific package for Ideogram V3 on RunAPI. Use this package for image generation, image editing, and creative production workflows when your application needs request bodies, task status lookup, and consistent RunAPI errors in Python.

This README is the Python package guide inside the public `ideogram-v3-sdk` repository. For the repository overview, start at `../README.md`; for model details, use https://runapi.ai/models/ideogram-v3; for API reference, use https://runapi.ai/docs#ideogram-v3; for SDK docs, use https://runapi.ai/docs#sdk-ideogram-v3.

## Install

```bash
pip install runapi-ideogram-v3
```

## Quick start

```python
from runapi.ideogram_v3 import IdeogramV3Client

client = IdeogramV3Client()  # reads RUNAPI_API_KEY, or pass api_key="sk-..."

task = client.text_to_image.create(
    model="ideogram-v3-text-to-image",
    prompt="A cinematic lakeside at twilight",
    aspect_ratio="16:9",
    rendering_speed="quality",
)
status = client.text_to_image.get(task.id)

edit = client.edit_image.create(
    model="ideogram-v3-edit",
    prompt="Replace the sky with aurora",
    source_image_url="https://cdn.runapi.ai/public/samples/image.jpg",
    mask_url="https://cdn.runapi.ai/public/samples/mask.png",
)
```

Use `create` to submit a task and return quickly, `get` to fetch the latest task state, and `run` to create and poll until completion:

```python
result = client.text_to_image.run(
    model="ideogram-v3-text-to-image",
    prompt="A serene mountain lake at dawn",
)
print(result.images[0].url)
```

In web request handlers, prefer `create` plus webhook or later `get` polling so a worker is not held open.

RunAPI-generated file URLs are temporary. Download and store generated images, videos, audio, or other files in your own durable storage within 7 days; do not treat returned URLs as long-term assets.

## Language notes

Pass parameters as keyword arguments and catch the `runapi.ideogram_v3` error classes when building image jobs or scripts. The available resources are `text_to_image`, `edit_image`, `remix_image`, and `reframe_image`. Keep `RUNAPI_API_KEY` in the environment or your secret manager; never commit API keys or callback secrets.

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
