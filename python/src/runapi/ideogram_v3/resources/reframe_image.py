"""Ideogram V3 reframe-image resource (model: ideogram-v3-reframe)."""

from __future__ import annotations

from typing import Any, Dict

from runapi.core import Resource, ValidationError

from .._validators import validate_output_count
from ..types import (
    ASPECT_RATIOS,
    REFRAME_MODEL,
    RENDERING_SPEEDS,
    STYLES,
    CompletedIdeogramResponse,
    IdeogramResponse,
)


class ReframeImage(Resource):
    """Reframe a source image to a new aspect ratio with Ideogram V3."""

    ENDPOINT = "/api/v1/ideogram_v3/reframe_image"
    RESPONSE_CLASS = IdeogramResponse
    COMPLETED_RESPONSE_CLASS = CompletedIdeogramResponse

    def run(self, **params: Any) -> Any:
        """Create a reframe-image task and poll until it completes.

        Args:
            **params: Reframe-image parameters (model, source_image_url, aspect_ratio, ...).

        Returns:
            The completed (narrowed) response.
        """
        task = self.create(**params)
        return self._poll_until_complete(lambda: self.get(task.id))

    def create(self, **params: Any) -> Any:
        """Create a reframe-image task and return immediately with an ``id``.

        Args:
            **params: Reframe-image parameters (model, source_image_url, aspect_ratio, ...).

        Returns:
            The task creation result with an id.
        """
        compacted = self._compact_params(params)
        self._validate_params(compacted)
        return self._request("post", self.ENDPOINT, body=compacted)

    def get(self, id: str) -> Any:
        """Fetch the current status of a reframe-image task.

        Args:
            id: The task id.

        Returns:
            The current task status.
        """
        return self._request("get", f"{self.ENDPOINT}/{id}")

    def _validate_params(self, params: Dict[str, Any]) -> None:
        model = params.get("model")
        if not model:
            raise ValidationError("model is required")
        if model != REFRAME_MODEL:
            raise ValidationError(f"Invalid model: {model}. Must be {REFRAME_MODEL}")

        if not params.get("source_image_url"):
            raise ValidationError("source_image_url is required")
        if not params.get("aspect_ratio"):
            raise ValidationError("aspect_ratio is required")

        self._validate_optional(params, "aspect_ratio", ASPECT_RATIOS)
        self._validate_optional(params, "rendering_speed", RENDERING_SPEEDS)
        self._validate_optional(params, "style", STYLES)
        validate_output_count(params)
