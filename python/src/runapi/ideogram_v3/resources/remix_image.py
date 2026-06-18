"""Ideogram V3 remix-image resource (model: ideogram-v3-remix)."""

from __future__ import annotations

from typing import Any, Dict

from runapi.core import Resource, ValidationError

from .._validators import validate_output_count
from ..types import (
    ASPECT_RATIOS,
    CHARACTER_REMIX_MODEL,
    CHARACTER_STYLES,
    REMIX_MODEL,
    RENDERING_SPEEDS,
    STYLES,
    CompletedIdeogramResponse,
    IdeogramResponse,
)


class RemixImage(Resource):
    """Remix a source image with Ideogram V3 models."""

    ENDPOINT = "/api/v1/ideogram_v3/remix_image"
    RESPONSE_CLASS = IdeogramResponse
    COMPLETED_RESPONSE_CLASS = CompletedIdeogramResponse
    PROMPT_MAX_LENGTH = 5000
    STRENGTH_MIN = 0.01
    CHARACTER_REMIX_STRENGTH_MIN = 0.1
    STRENGTH_MAX = 1.0

    def run(self, **params: Any) -> Any:
        """Create a remix-image task and poll until it completes.

        Args:
            **params: Remix-image parameters (model, prompt, source_image_url, ...).

        Returns:
            The completed (narrowed) response.
        """
        task = self.create(**params)
        return self._poll_until_complete(lambda: self.get(task.id))

    def create(self, **params: Any) -> Any:
        """Create a remix-image task and return immediately with an ``id``.

        Args:
            **params: Remix-image parameters (model, prompt, source_image_url, ...).

        Returns:
            The task creation result with an id.
        """
        compacted = self._compact_params(params)
        self._validate_params(compacted)
        return self._request("post", self.ENDPOINT, body=compacted)

    def get(self, id: str) -> Any:
        """Fetch the current status of a remix-image task.

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
        if model not in (REMIX_MODEL, CHARACTER_REMIX_MODEL):
            raise ValidationError(
                f"Invalid model: {model}. Must be {REMIX_MODEL} or {CHARACTER_REMIX_MODEL}"
            )

        prompt = params.get("prompt")
        if not (isinstance(prompt, str) and prompt):
            raise ValidationError("prompt is required")
        if len(prompt) > self.PROMPT_MAX_LENGTH:
            raise ValidationError(f"prompt must be at most {self.PROMPT_MAX_LENGTH} characters")

        if not params.get("source_image_url"):
            raise ValidationError("source_image_url is required")

        self._validate_optional(params, "rendering_speed", RENDERING_SPEEDS)
        style_values = CHARACTER_STYLES if model == CHARACTER_REMIX_MODEL else STYLES
        self._validate_optional(params, "style", style_values)
        self._validate_optional(params, "aspect_ratio", ASPECT_RATIOS)
        self._validate_character_fields(params, model)
        validate_output_count(params)
        self._validate_strength(params, model)

    def _validate_character_fields(self, params: Dict[str, Any], model: str) -> None:
        refs = params.get("reference_image_urls")
        if model == CHARACTER_REMIX_MODEL:
            if not (isinstance(refs, list) and refs):
                raise ValidationError("reference_image_urls is required")
        elif refs or params.get("style_reference_image_urls") or params.get("reference_mask_urls"):
            raise ValidationError(f"character remix fields are not supported for {model}")

    def _validate_strength(self, params: Dict[str, Any], model: str) -> None:
        strength = params.get("strength")
        if strength is None:
            return
        minimum = (
            self.CHARACTER_REMIX_STRENGTH_MIN
            if model == CHARACTER_REMIX_MODEL
            else self.STRENGTH_MIN
        )
        try:
            numeric = float(strength)
        except (TypeError, ValueError):
            numeric = None
        if numeric is None or numeric < minimum or numeric > self.STRENGTH_MAX:
            raise ValidationError(f"strength must be between {minimum} and {self.STRENGTH_MAX}")
