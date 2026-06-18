"""Ideogram V3 edit-image resource (model: ideogram-v3-edit)."""

from __future__ import annotations

from typing import Any, Dict

from runapi.core import Resource, ValidationError

from .._validators import validate_output_count
from ..types import (
    CHARACTER_EDIT_MODEL,
    CHARACTER_STYLES,
    EDIT_MODEL,
    RENDERING_SPEEDS,
    CompletedIdeogramResponse,
    IdeogramResponse,
)


class EditImage(Resource):
    """Inpaint an image with a mask using Ideogram V3 models."""

    ENDPOINT = "/api/v1/ideogram_v3/edit_image"
    RESPONSE_CLASS = IdeogramResponse
    COMPLETED_RESPONSE_CLASS = CompletedIdeogramResponse
    PROMPT_MAX_LENGTH = 5000

    def run(self, **params: Any) -> Any:
        """Create an edit-image task and poll until it completes.

        Args:
            **params: Edit-image parameters (model, prompt, source_image_url, mask_url, ...).

        Returns:
            The completed (narrowed) response.
        """
        task = self.create(**params)
        return self._poll_until_complete(lambda: self.get(task.id))

    def create(self, **params: Any) -> Any:
        """Create an edit-image task and return immediately with an ``id``.

        Args:
            **params: Edit-image parameters (model, prompt, source_image_url, mask_url, ...).

        Returns:
            The task creation result with an id.
        """
        compacted = self._compact_params(params)
        self._validate_params(compacted)
        return self._request("post", self.ENDPOINT, body=compacted)

    def get(self, id: str) -> Any:
        """Fetch the current status of an edit-image task.

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
        if model not in (EDIT_MODEL, CHARACTER_EDIT_MODEL):
            raise ValidationError(
                f"Invalid model: {model}. Must be {EDIT_MODEL} or {CHARACTER_EDIT_MODEL}"
            )

        prompt = params.get("prompt")
        if not (isinstance(prompt, str) and prompt):
            raise ValidationError("prompt is required")
        if len(prompt) > self.PROMPT_MAX_LENGTH:
            raise ValidationError(f"prompt must be at most {self.PROMPT_MAX_LENGTH} characters")

        if not params.get("source_image_url"):
            raise ValidationError("source_image_url is required")
        if not params.get("mask_url"):
            raise ValidationError("mask_url is required")

        self._validate_optional(params, "rendering_speed", RENDERING_SPEEDS)
        self._validate_character_fields(params, model)

    def _validate_character_fields(self, params: Dict[str, Any], model: str) -> None:
        refs = params.get("reference_image_urls")
        if model == CHARACTER_EDIT_MODEL:
            if not (isinstance(refs, list) and refs):
                raise ValidationError("reference_image_urls is required")
            self._validate_optional(params, "style", CHARACTER_STYLES)
        elif refs or params.get("style"):
            raise ValidationError(f"character edit fields are not supported for {model}")
        validate_output_count(params)
