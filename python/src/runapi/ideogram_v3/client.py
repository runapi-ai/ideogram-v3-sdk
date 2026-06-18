"""Ideogram V3 client."""

from __future__ import annotations

from typing import Any, Optional

from runapi.core import ClientOptions, HttpClient, resolve_api_key

from .resources.edit_image import EditImage
from .resources.reframe_image import ReframeImage
from .resources.remix_image import RemixImage
from .resources.text_to_image import TextToImage


class IdeogramV3Client:
    """Ideogram V3 image generation client.

    Example::

        client = IdeogramV3Client(api_key="sk-...")
        result = client.text_to_image.run(
            model="ideogram-v3-text-to-image",
            prompt="A cinematic lakeside at twilight",
        )
    """

    def __init__(self, api_key: Optional[str] = None, **options: Any) -> None:
        resolved_api_key = resolve_api_key(api_key)
        client_options = ClientOptions(api_key=resolved_api_key, **options)
        http = client_options.http_client or HttpClient(client_options)
        self.text_to_image = TextToImage(http)
        self.edit_image = EditImage(http)
        self.remix_image = RemixImage(http)
        self.reframe_image = ReframeImage(http)
