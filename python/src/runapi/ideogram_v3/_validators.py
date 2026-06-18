"""Shared validators for Ideogram V3 resources."""

from __future__ import annotations

from typing import Any, Dict

from runapi.core import ValidationError

from .types import OUTPUT_COUNTS


def validate_output_count(params: Dict[str, Any]) -> None:
    output_count = params.get("output_count")
    if output_count is None:
        return
    if not isinstance(output_count, bool) and output_count in OUTPUT_COUNTS:
        return
    joined = ", ".join(str(option) for option in OUTPUT_COUNTS)
    raise ValidationError(f"Invalid output_count: {output_count}. Must be one of: {joined}")
