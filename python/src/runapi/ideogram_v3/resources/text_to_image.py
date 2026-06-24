"""Ideogram V3 text-to-image resource (model: ideogram-v3-text-to-image)."""

from __future__ import annotations

from typing import Any, Dict

from runapi.core import Resource, ValidationError

from ..contract_gen import CONTRACT
from ..types import (
    CHARACTER_MODEL,
    CompletedIdeogramResponse,
    IdeogramResponse,
)


class TextToImage(Resource):
    """Generate images from text prompts with Ideogram V3 models."""

    ENDPOINT = "/api/v1/ideogram_v3/text_to_image"
    RESPONSE_CLASS = IdeogramResponse
    COMPLETED_RESPONSE_CLASS = CompletedIdeogramResponse
    PROMPT_MAX_LENGTH = 5000

    def run(self, **params: Any) -> Any:
        """Create a text-to-image task and poll until it completes.

        Args:
            **params: Text-to-image parameters (model, prompt, ...).

        Returns:
            The completed (narrowed) response.
        """
        task = self.create(**params)
        return self._poll_until_complete(lambda: self.get(task.id))

    def create(self, **params: Any) -> Any:
        """Create a text-to-image task and return immediately with an ``id``.

        Args:
            **params: Text-to-image parameters (model, prompt, ...).

        Returns:
            The task creation result with an id.
        """
        compacted = self._compact_params(params)
        self._validate_params(compacted)
        return self._request("post", self.ENDPOINT, body=compacted)

    def get(self, id: str) -> Any:
        """Fetch the current status of a text-to-image task.

        Args:
            id: The task id.

        Returns:
            The current task status.
        """
        return self._request("get", f"{self.ENDPOINT}/{id}")

    def _validate_params(self, params: Dict[str, Any]) -> None:
        self._validate_contract(CONTRACT["text-to-image"], params)
        model = params.get("model")

        prompt = params.get("prompt")
        if not (isinstance(prompt, str) and prompt):
            raise ValidationError("prompt is required")
        if len(prompt) > self.PROMPT_MAX_LENGTH:
            raise ValidationError(f"prompt must be at most {self.PROMPT_MAX_LENGTH} characters")

        self._validate_character_refs(params, model)

    def _validate_character_refs(self, params: Dict[str, Any], model: str) -> None:
        refs = params.get("reference_image_urls")
        if model == CHARACTER_MODEL:
            if not (isinstance(refs, list) and refs):
                raise ValidationError("reference_image_urls is required")
        elif refs:
            raise ValidationError(f"reference_image_urls is not supported for {model}")
