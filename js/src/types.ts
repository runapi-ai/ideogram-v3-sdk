import type { AsyncTaskStatus } from '@runapi.ai/core';

/**
 * All Ideogram V3 model slugs. Standard models handle generation, editing,
 * remix, and reframing; character variants add character consistency from
 * reference images.
 */
export type IdeogramV3Model =
  | 'ideogram-v3-text-to-image'
  | 'ideogram-v3-edit'
  | 'ideogram-v3-remix'
  | 'ideogram-v3-character'
  | 'ideogram-v3-character-edit'
  | 'ideogram-v3-character-remix'
  | 'ideogram-v3-reframe';

/** Speed-quality tradeoff: turbo is fastest, quality is highest fidelity. */
export type RenderingSpeed = 'turbo' | 'balanced' | 'quality';
/** Visual style for standard (non-character) models. */
export type IdeogramStyle = 'auto' | 'general' | 'realistic' | 'design';
/** Visual style for character-consistency models (fiction adds stylized rendering). */
export type IdeogramCharacterStyle = 'auto' | 'realistic' | 'fiction';
/** Output aspect ratio. */
export type AspectRatio =
  | '1:1'
  | '3:4'
  | '9:16'
  | '4:3'
  | '16:9';
/** Number of images to generate per request (1-4). */
export type OutputCount = 1 | 2 | 3 | 4;

/**
 * Parameters for text-to-image generation.
 * Use `ideogram-v3-character` with `reference_image_urls` for character
 * consistency across generated images.
 */
export interface TextToImageParams {
  model: 'ideogram-v3-text-to-image' | 'ideogram-v3-character';
  /** Image description, max 5000 characters. */
  prompt: string;
  /** Webhook URL for completion notifications. */
  callback_url?: string;
  /** Speed-quality tradeoff. */
  rendering_speed?: RenderingSpeed;
  /** Visual style preset. Character models accept IdeogramCharacterStyle. */
  style?: IdeogramStyle | IdeogramCharacterStyle;
  /** Let MagicPrompt expand the prompt for richer detail. */
  enable_prompt_expansion?: boolean;
  aspect_ratio?: AspectRatio;
  output_count?: OutputCount;
  /** Deterministic seed for reproducible results. */
  seed?: number;
  /** Elements to exclude from the output, max 5000 characters. */
  negative_prompt?: string;
  /** Required for ideogram-v3-character; character reference images. */
  reference_image_urls?: string[];
}

/**
 * Parameters for inpaint editing with a mask.
 * The mask defines which region of the source image to regenerate.
 */
export interface EditImageParams {
  model: 'ideogram-v3-edit' | 'ideogram-v3-character-edit';
  /** Fill text for the masked area, max 5000 characters. */
  prompt: string;
  /** Source image URL (JPEG/PNG/WEBP, max 10 MB). */
  source_image_url: string;
  /** Inpaint mask URL. Must match source image dimensions. */
  mask_url: string;
  /** Webhook URL for completion notifications. */
  callback_url?: string;
  rendering_speed?: RenderingSpeed;
  /** Style preset. Only applicable for character-edit models. */
  style?: IdeogramCharacterStyle;
  /** Let MagicPrompt expand the prompt for richer detail. */
  enable_prompt_expansion?: boolean;
  output_count?: OutputCount;
  /** Deterministic seed for reproducible results. */
  seed?: number;
  /** Required for ideogram-v3-character-edit; character reference images. */
  reference_image_urls?: string[];
}

/**
 * Parameters for image remix.
 * Strength controls how much the output deviates from the source (0.01-1.0,
 * or 0.1-1.0 for character-remix models).
 */
export interface RemixImageParams {
  model: 'ideogram-v3-remix' | 'ideogram-v3-character-remix';
  /** Transformation description, max 5000 characters. */
  prompt: string;
  /** Source image URL (JPEG/PNG/WEBP, max 10 MB). */
  source_image_url: string;
  /** Webhook URL for completion notifications. */
  callback_url?: string;
  rendering_speed?: RenderingSpeed;
  /** Visual style preset. Character models accept IdeogramCharacterStyle. */
  style?: IdeogramStyle | IdeogramCharacterStyle;
  /** Let MagicPrompt expand the prompt for richer detail. */
  enable_prompt_expansion?: boolean;
  aspect_ratio?: AspectRatio;
  output_count?: OutputCount;
  /** Deterministic seed for reproducible results. */
  seed?: number;
  /** How much the output deviates from source. Range depends on model variant. */
  strength?: number;
  /** Elements to exclude from the output, max 5000 characters. */
  negative_prompt?: string;
  /** Required for ideogram-v3-character-remix; character reference images. */
  reference_image_urls?: string[];
  /** Style reference images for character-remix models. */
  style_reference_image_urls?: string[];
  /** Masks for character reference images (character-remix only). */
  reference_mask_urls?: string[];
}

/**
 * Parameters for image reframing.
 * Extends or crops an image to a new aspect ratio without regenerating content.
 * Note: no prompt parameter -- the model preserves the original content.
 */
export interface ReframeImageParams {
  model: 'ideogram-v3-reframe';
  /** Source image URL (JPEG/PNG/WEBP, max 10 MB). */
  source_image_url: string;
  /** Target aspect ratio. Required. */
  aspect_ratio: AspectRatio;
  /** Webhook URL for completion notifications. */
  callback_url?: string;
  rendering_speed?: RenderingSpeed;
  style?: IdeogramStyle;
  output_count?: OutputCount;
  /** Deterministic seed for reproducible results. */
  seed?: number;
}

/** Acknowledged task with its server-assigned ID. */
export interface TaskCreateResponse {
  id: string;
}

/** A single generated image with its CDN URL. */
export interface Image {
  url: string;
}

/**
 * Normalized response for all Ideogram V3 endpoints.
 * `images` is populated once `status` reaches `'completed'`.
 */
export interface IdeogramV3Response {
  id: string;
  status: AsyncTaskStatus;
  images?: Image[];
  error?: string;
  [key: string]: unknown;
}

/**
 * Resolved response returned by the `run()` method after polling sees
 * `status: 'completed'`. Narrows the base response so `images` is
 * guaranteed non-optional in user code.
 */
export type CompletedIdeogramV3Response = IdeogramV3Response & {
  status: 'completed';
  images: Image[];
};
