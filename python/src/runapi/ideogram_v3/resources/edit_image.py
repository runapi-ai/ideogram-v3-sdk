"""Ideogram V3 edit-image resource (model: ideogram-v3-edit)."""

from __future__ import annotations

from typing import Any, Dict, Optional

from runapi.core import Resource, ValidationError, RequestOptions

from ..contract_gen import CONTRACT
from ..types import (
    CHARACTER_EDIT_MODEL,
    CompletedIdeogramResponse,
    IdeogramResponse,
)


class EditImage(Resource):
    """Inpaint an image with a mask using Ideogram V3 models."""

    ENDPOINT = "/api/v1/ideogram_v3/edit_image"
    RESPONSE_CLASS = IdeogramResponse
    COMPLETED_RESPONSE_CLASS = CompletedIdeogramResponse
    PROMPT_MAX_LENGTH = 5000

    def run(self, options: Optional[RequestOptions] = None, **params: Any) -> Any:
        """Create an edit-image task and poll until it completes.

        Args:
            **params: Edit-image parameters (model, prompt, source_image_url, mask_url, ...).

        Returns:
            The completed (narrowed) response.
        """
        task = self.create(options=options, **params)
        return self._poll_until_complete(lambda: self.get(task.id, options=options))

    def create(self, options: Optional[RequestOptions] = None, **params: Any) -> Any:
        """Create an edit-image task and return immediately with an ``id``.

        Args:
            **params: Edit-image parameters (model, prompt, source_image_url, mask_url, ...).

        Returns:
            The task creation result with an id.
        """
        compacted = self._compact_params(params)
        self._validate_params(compacted)
        return self._request("post", self.ENDPOINT, body=compacted, options=options)

    def get(self, id: str, options: Optional[RequestOptions] = None) -> Any:
        """Fetch the current status of an edit-image task.

        Args:
            id: The task id.

        Returns:
            The current task status.
        """
        return self._request("get", f"{self.ENDPOINT}/{id}", options=options)

    def _validate_params(self, params: Dict[str, Any]) -> None:
        self._validate_contract(CONTRACT["edit-image"], params)
        model = params.get("model")

        prompt = params.get("prompt")
        if not (isinstance(prompt, str) and prompt):
            raise ValidationError("prompt is required")
        if len(prompt) > self.PROMPT_MAX_LENGTH:
            raise ValidationError(f"prompt must be at most {self.PROMPT_MAX_LENGTH} characters")

        if not params.get("mask_url"):
            raise ValidationError("mask_url is required")

        self._validate_character_fields(params, model)

    def _validate_character_fields(self, params: Dict[str, Any], model: str) -> None:
        refs = params.get("reference_image_urls")
        if model == CHARACTER_EDIT_MODEL:
            if not (isinstance(refs, list) and refs):
                raise ValidationError("reference_image_urls is required")
        elif refs or params.get("style"):
            raise ValidationError(f"character edit fields are not supported for {model}")
