import type { AsyncTaskStatus } from '@runapi.ai/core';

export type IdeogramV3Model =
  | 'ideogram-v3-text-to-image'
  | 'ideogram-v3-edit'
  | 'ideogram-v3-remix'
  | 'ideogram-v3-character'
  | 'ideogram-v3-character-edit'
  | 'ideogram-v3-character-remix'
  | 'ideogram-v3-reframe';

export type RenderingSpeed = 'turbo' | 'balanced' | 'quality';
export type IdeogramStyle = 'auto' | 'general' | 'realistic' | 'design';
export type IdeogramCharacterStyle = 'auto' | 'realistic' | 'fiction';
export type AspectRatio =
  | '1:1'
  | '3:4'
  | '9:16'
  | '4:3'
  | '16:9';
export type OutputCount = 1 | 2 | 3 | 4;

export interface TextToImageParams {
  model: 'ideogram-v3-text-to-image' | 'ideogram-v3-character';
  prompt: string;
  callback_url?: string;
  rendering_speed?: RenderingSpeed;
  style?: IdeogramStyle | IdeogramCharacterStyle;
  enable_prompt_expansion?: boolean;
  aspect_ratio?: AspectRatio;
  output_count?: OutputCount;
  seed?: number;
  negative_prompt?: string;
  reference_image_urls?: string[];
}

export interface EditImageParams {
  model: 'ideogram-v3-edit' | 'ideogram-v3-character-edit';
  prompt: string;
  source_image_url: string;
  mask_url: string;
  callback_url?: string;
  rendering_speed?: RenderingSpeed;
  style?: IdeogramCharacterStyle;
  enable_prompt_expansion?: boolean;
  output_count?: OutputCount;
  seed?: number;
  reference_image_urls?: string[];
}

export interface RemixImageParams {
  model: 'ideogram-v3-remix' | 'ideogram-v3-character-remix';
  prompt: string;
  source_image_url: string;
  callback_url?: string;
  rendering_speed?: RenderingSpeed;
  style?: IdeogramStyle | IdeogramCharacterStyle;
  enable_prompt_expansion?: boolean;
  aspect_ratio?: AspectRatio;
  output_count?: OutputCount;
  seed?: number;
  strength?: number;
  negative_prompt?: string;
  reference_image_urls?: string[];
  style_reference_image_urls?: string[];
  reference_mask_urls?: string[];
}

export interface ReframeImageParams {
  model: 'ideogram-v3-reframe';
  source_image_url: string;
  aspect_ratio: AspectRatio;
  callback_url?: string;
  rendering_speed?: RenderingSpeed;
  style?: IdeogramStyle;
  output_count?: OutputCount;
  seed?: number;
}

export interface TaskCreateResponse {
  id: string;
}

export interface Image {
  url: string;
}

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
